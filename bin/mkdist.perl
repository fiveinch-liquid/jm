#!/usr/bin/perl
#
# build distribution tree.
#
# first version Thu Aug 19 00:53:30 JST 1999
#     by Tenkou N. Hattori <tnh@aurora.dti.ne.jp>
#
BEGIN{
    $epath = `dirname $0`; chomp $epath;
    unshift (@INC, $epath);
}
use JMcommon ('getCommentInfo');
use JMtl ('line2hash', 'hash2line');
use JMtl2 ('line2hash_ver2');
use strict 'vars';

my ($idx_header, $idx_footer);
#
# $CVSROOT は CVS リポジトリの root,
# $DISTROOT は配布アーカイブイメージの root.
#
if (@ARGV < 3) {die "$0 srcroot dstroot pod2man\n"};

my $CVSROOT = $ARGV[0];
unless (-d $CVSROOT) {die "$CVSROOT does not exist\n"};

my $DISTROOT = $ARGV[1];

my $POD2MAN = $ARGV[2];
unless (-x $POD2MAN) {die "$POD2MAN is not executable\n"};

# for debugging purpose:
#
#my $MANROOT = "/home/nakano/text/JM/imp/manual";
#my $DISTROOT = "/var/tmp/JM/man-pages-ja";

#
# いったん $DISTROOT/manual をお掃除。
#
if (-d "$DISTROOT/manual") {
    system("rm -rf $DISTROOT/manual");
}
system("mkdir -p $DISTROOT/manual");

my (%roff_hash, %roff_status, %link_hash);
#
# $CVSROOT/manual/$pkg/translation_list の scan.
#
print "scanning translation_list's...\n";
open RL,"find $CVSROOT/manual -name translation_list | sort |";
while(<RL>){
    print;
    chomp;
    my $tl = $_;

    unless(/.*manual\/([^\/]*)\/translation_list/){next;}
    my $pkg=$1;

    # release または contrib ディレクトリを持たないパッケージは処理対象としない
    if (! -d "$CVSROOT/manual/$pkg/release" && ! -d "$CVSROOT/manual/$pkg/contrib") {next;}

    system "mkdir -p $DISTROOT/manual/$pkg/";
    system "cp $tl $DISTROOT/manual/$pkg";

    my %ti_common = getCommentInfo($tl);
    my $tl_ver = $ti_common{'TL_VERSION'};

    open TL, $tl || die "cannot open $tl";
    while (<TL>){
	chomp;
	my %ti_ver;
	if ($tl_ver == 2) {
	  %ti_ver = line2hash_ver2($_);
	} else {
	  %ti_ver = line2hash($_);
	}
	# ハッシュが空の場合(=コメント行であった場合)は next
	if (!%ti_ver) { next; }

	# ハッシュを統合する
	# ( ti_common: 共通ハッシュ, ti_ver: バージョン別ハッシュ )
	my %ti = (%ti_common, %ti_ver);

	my $name = $ti{fname};
	my $sec = $ti{sec};
	my $page = "$tl_ver,$pkg,$name,$sec";
	$roff_status{"$page"} = $ti{stat};

	if ($ti{kind} eq roff && $ti{stat} =~ /^cnt/) {
	    my $src;
	    if ($tl_ver == 2) {
	        $src = "$pkg/contrib/$sec/$name";
	    } else {
	        $src = "$pkg/contrib/man$sec/$name.$sec";
	    }
	    if (-f "$CVSROOT/manual/$src") {
		$roff_hash{"$page"} = $src;
		print "collect roff: $page <= $src\n";
	    }
	    next;
	}

	if ($ti{kind} eq roff && -d "$CVSROOT/manual/$pkg/release") {
	    my $src;
	    if ($tl_ver == 2) {
	        $src = "$pkg/release/$sec/$name";
	    } else {
	        $src = "$pkg/release/man$sec/$name.$sec";
	    }
	    if (-f "$CVSROOT/manual/$src" && $ti{stat} ne "1st_non") {
		$roff_hash{"$page"} = $src;
		print "collect roff: $page <= $src\n";
	    }
	    next;
	}
    }

    # もう一度、先頭から走査して、リンクファイルについて
    # そのリンク先が翻訳済みとして記述されていたかどうかを
    # 確認し、リンクのための出力処理を行う。
    # (リンク行のステータスを利用しない=記述内容を信用しない)
    seek(TL, 0, 0);
    while (<TL>){
	chomp;
	my %ti_ver;
	if ($tl_ver == 2) {
	  %ti_ver = line2hash_ver2($_);
	} else {
	  %ti_ver = line2hash($_);
	}
	# ハッシュが空の場合(=コメント行であった場合)は next
	if (!%ti_ver) { next; }

	# ハッシュを統合する
	# ( ti_common: 共通ハッシュ, ti_ver: バージョン別ハッシュ )
	my %ti = (%ti_common, %ti_ver);

	my $name = $ti{fname};
	my $sec  = $ti{sec};
	my $page = "$tl_ver,$pkg,$name,$sec";
	my $lname = $ti{lname};
	my $lsec  = $ti{lsec};
	my $lpage = "$tl_ver,$pkg,$lname,$lsec";
	if ($lsec ne "" && $lname ne "") {
	    my $dst_status = $roff_status{"$lpage"};
	    if ($dst_status !~ /^1st/) {
		my $dst;
		if ($tl_ver == 2) {
		    $dst = ".so man$lsec/$lname";
		} else {
		    $dst = ".so man$lsec/$lname.$lsec";
		}
		$link_hash{"$page"} = $dst;
		print "collect link: $page => $dst\n";
	    }
	}
    }
    close TL;
}
close RL;

#
# copy 開始
#
foreach my $fkey (sort keys %roff_hash){
    my ($tl_ver,$pkg,$name,$sec)=split /,/, $fkey;

    my $dstdir;
    my $dstfile;
    if ($tl_ver == 2) {
        $dstdir = "$DISTROOT/manual/$pkg/$sec";
        $dstfile = "$dstdir/$name";
    } else {
        $dstdir = "$DISTROOT/manual/$pkg/man$sec";
        $dstfile = "$dstdir/$name.$sec";
    }
    my $srcfile = "$CVSROOT/manual/$roff_hash{$fkey}";

    print "copy $srcfile => $dstfile\n";
    system "mkdir -p $dstdir";
    system "cp $srcfile $dstfile";
}

#
# make symlinks
#
foreach my $fkey (sort keys %link_hash){
    my ($tl_ver,$pkg, $name, $sec) = split /,/, $fkey;

    my $dstdir;
    my $dstfile;
    if ($tl_ver == 2) {
        $dstdir = "$DISTROOT/manual/$pkg/$sec";
        $dstfile = "$dstdir/$name";
    } else {
        $dstdir = "$DISTROOT/manual/$pkg/man$sec";
        $dstfile = "$dstdir/$name.$sec";
    }

    print "cat \"$link_hash{$fkey}\" > $dstfile\n";
    system "mkdir -p $dstdir";
    open DF, "> $dstfile" || die "cannot open $dstfile\n";
    print DF "$link_hash{$fkey}\n";
    close DF;
}

#
# pod データ収集
#
print "TRANSLATING pod -> man\n";
my (%pod_hash);
#
# $CVSROOT/pod/$pkg/translation_list の scan.
#
print "scanning translation_list's...\n";
open RL,"find $CVSROOT/pod -name translation_list|";
while(<RL>){
    print;
    chomp;
    my $tl = $_;

    unless(/.*pod\/([^\/]*)\/translation_list/){next;}
    my $pkg=$1;

    system "mkdir -p $DISTROOT/pod/$pkg/";
    system "cp $tl $DISTROOT/pod/$pkg";

    my %ti_common = getCommentInfo($tl);
    my $tl_ver = $ti_common{'TL_VERSION'};

    open TL, $tl || die "cannot open $tl";
    while (<TL>){
	chomp;
	my %ti_ver;
	if ($tl_ver == 2) {
	  %ti_ver = line2hash_ver2($_);
	} else {
	  %ti_ver = line2hash($_);
	}
	# ハッシュが空の場合(=コメント行であった場合)は next
	if (!%ti_ver) { next; }

	# ハッシュを統合する
	# ( ti_common: 共通ハッシュ, ti_ver: バージョン別ハッシュ )
	my %ti = (%ti_common, %ti_ver);

	my $name = $ti{fname};
	my $page = "$pkg,$name";

	if ($ti{kind} eq roff && $ti{stat} =~ /^up/) {
	    my $src = "$pkg/release/$name.pod";
	    $pod_hash{"$page"} = $src;
	    print "collect pod : $page <= $src\n";
	    next;
	}
    }
    close TL;
}
close RL;

#
# 変換開始
#
foreach my $fkey (sort keys %pod_hash){
    my ($pkg,$name)=split /,/, $fkey;

    my $dstdir = "$DISTROOT/manual/$pkg/man1";
    my $dstfile = "$dstdir/$name.1";
    my $srcfile = "$CVSROOT/pod/$pod_hash{$fkey}";

    print "translate $srcfile => $dstfile\n";
    system "mkdir -p $dstdir";
    system "$POD2MAN --utf8 $srcfile > $dstfile";
}
