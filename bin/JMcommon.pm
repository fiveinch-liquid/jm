#!/usr/bin/perl
package JMcommon;

require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(getCommentInfo);

#
# コメント行内のキーワードとその値を %thash に取り込む。
#
sub getCommentInfo($) {
    my %thash;
    my $tl = $_;
    my $ver = 1;

    open TL, $tl || die "cannot open $tl";
    while (<TL>){
      chomp;
      my $line = $_;

      # 行頭がコメント記号(#)で始まる場合
      if ($line =~ /^\#/) {

        # キーワードコメント行(#. KEYWORD VALUE)の場合
        if ($line =~ /^\#\.[ \t]*([a-zA-Z_]+)[ \t]+(.*)$/) {
          $thash{$1} = $2;
        }
      }
    }
    close TL;

    # コメント行内のキーワード指定に TL_VERSION がない場合、
    # TL_VERSION を 1 として %thash に登録する。
    if ($thash{'TL_VERSION'} eq '') {
      $thash{'TL_VERSION'} = 1;
    }

    # translation_list バージョン１の各キーに合わせるために、
    # 必要なキーと値を生成する。

    # パッケージ名: pkg ＜＝ PACKAGE_NAME
    $thash{'pkg'} = $thash{'PACKAGE_NAME'};

    # パッケージバージョン: over,dver,rver ＜＝ PACKAGE_VER
    $thash{'over'} = $thash{'PACKAGE_VER'};
    $thash{'dver'} = $thash{'PACKAGE_VER'};
    $thash{'rver'} = $thash{'PACKAGE_VER'};

    # パッケージリリース日付: odat ＜＝ PACKAGE_DATE
    $thash{'odat'} = $thash{'PACKAGE_DATE'};

    %thash;
}
