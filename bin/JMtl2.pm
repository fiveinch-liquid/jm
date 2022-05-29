#!/usr/bin/perl
package JMtl2;

require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(line2hash_ver2);

#
# entry → hash.
#
sub line2hash_ver2($) {
    my ($entry) = @_;
    my %thash;
    
    chomp $entry;

    # コメント行であった場合は空ハッシュを返して終了
    if ($entry =~ /^\#/) { return %thash; }

    my @member = split /\|/, $entry;
    
    my $status_str = &trim($member[0]);
    
    my ($stat);
    my $kind = 'roff';

    SW1: {
      #if ($mark eq '×') {$stat = '1st_non'; last SW1;}
      #if ($mark eq '▲') {$stat = '1st_rsv'; last SW1;}
      #if ($mark eq '△') {$stat = '1st_dft'; last SW1;}
      #if ($mark eq '●') {$stat = '1st_prf'; last SW1;}
      #if ($mark eq '☆') {$stat = 'upd_non'; last SW1;}
      #if ($mark eq '■') {$stat = 'upd_rsv'; last SW1;}
      #if ($mark eq '□') {$stat = 'upd_dft'; last SW1;}
      #if ($mark eq '◆') {$stat = 'upd_prf'; last SW1;}
      #if ($mark eq '○') {$stat = 'up2date'; last SW1;}
      #if ($mark eq '◎') {$stat = 'up2datR'; last SW1;}
      #if ($mark eq 'Ｃ') {$stat = 'cnt_upd'; last SW1;}
      #if ($mark eq 'ｃ') {$stat = 'cnt_old'; last SW1;}
      if ($status_str eq '未対応') {$stat = '1st_non'; last SW1;}
      if ($status_str eq '翻訳中') {$stat = '1st_rsv'; last SW1;}
      if ($status_str eq '翻訳完') {$stat = '1st_dft'; last SW1;}
      if ($status_str eq '校正中') {$stat = '1st_prf'; last SW1;}
      if ($status_str eq '校正完') {$stat = 'up2date'; last SW1;}
      if ($status_str eq '寄贈')   {$stat = 'cnt_upd'; last SW1;}
  
      $kind = 'link';
      #if ($mark eq '＠') {$stat = 'up2date'; last SW1;}
      #if ($mark eq '※') {$stat = '1st_non'; last SW1;}
      if ($status_str eq 'リンク') {$stat = '1st_non'; last SW1;}

      $kind = 'roff';
    }

    $thash{'mark'} = "$status_str";
    $thash{'kind'} = $kind;
    $thash{'stat'} = $stat;

    $thash{'fname'} = &trim($member[2]); # TLバージョン2 では拡張子込みのファイル名
    $thash{'sec'}   = &trim($member[1]); # TLバージョン2 では "man" + <num>

    $thash{'tdat'}  = &trim($member[5]);
    $thash{'tname'} = &trim($member[6]);
    $thash{'tmail'} = &trim($member[7]);
    $thash{'lname'} = &trim($member[4]); # TLバージョン2 では拡張子込みのファイル名
    $thash{'lsec'}  = &trim($member[3]); # TLバージョン2 では "man" + <num>

    $thash{'comment'} = $member[8];
    for (my $i = 9; $i <= $#member; $i++){
      $thash{'comment'} .= ":$member[$i]";
    }

    %thash;
}


sub trim {
  my $str = $_[0];
  $str =~ s/^[ \t]*(.*?)[ \t]*$/$1/;
  return $str;
}
