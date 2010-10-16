m4_dnl # $Id: repository.m4,v 1.8 2002/09/25 18:08:35 nakano Exp $
m4_dnl # index.m4: GNU m4 source for index.html.
m4_dnl # -------------------------------------------------------------------
m4_dnl #
m4_dnl # [その他に make 時点で依存を参照するファイル]
m4_dnl # jf_www.m4: 各種 M4 マクロ定義ファイル
m4_dnl #
m4_dnl # -------------------------------------------------------------------
m4_dnl
m4_define(_SUB_ONE)
m4_include(../jm_www.m4)
_EDIT_WARNING(translation_note)
_HEADER(`JM 文書の管理方法')

<P>
 JM Project では、CVS によって文書の管理をしています。
 このページでは、
 _LINK(#structure,リポジトリ内部の配置)
 と、 man ページの作業情報などが記述されたテキストデータベース
 _LINK(#translation_list,transalation_list)
 の書式に関する説明をします。
</P>

<H2><A NAME="structure">ディレクトリの構成</A></H2>
<P>
 JM Project の用いている CVS リポジトリのディレクトリ構成は
 以下のようになっています。
</P>
<PRE>
/ +- www
  |
  +- admin
  |
  +- manual -+- 0unclassified -
             |
             +- GNU_bash -
             |
             +- GNU_binutils -
                    :
</PRE>

<P>
 このうちの manual/ 以下が、本サイトの
 _LINK(../roff,roff ディレクトリ)
 以下にミラーされています。
 このディレクトリには、
 マニュアルの一次ソースとなるアーカイブパッケージ
 (例えば util-linux-2.9v.tar.gz など) の
 basename と同名のサブディレクトリ (util-linux) を設けます。
 ただし GNU のパッケージと LDP のパッケージだけには、
 便宜上 GNU_, LDP_ という prefix をつけています。
 このサブディレクトリを、以下では
 「パッケージディレクトリ」と呼びます。
</P>

<P>
 各パッケージディレクトリのサブ構造は以下のようになっています。
</P>

<PRE>
- pkg -+- ChangeLog
       +- translation_list
       +- original -+- man1
       |            +- man5
       |            +- man8
       |
       +- draft    -+- man1
       |            +- man5
       |            +- man8
       |
       +- release  -+- man1
       |            +- man5
       |            +- man8
       |
       +- contrib  -+- man1
                    +- man5
                    +- man8
</PRE>

<UL>
 <LI>ChangeLog ファイルは変更履歴を記述したファイルです。
  CVS システムで標準的に用いられれる形式です。</LI>

 <LI>translation_list は各マニュアルページのバージョンや作業情報、
  著作権情報等を含むテキストデータベースファイルです。
  このファイルの書式については
  _LINK(#translation_list,translation_list の書式)
  で説明します。</LI>

 <LI>ディレクトリ <tt>original/</tt> には、
  パッケージに含まれている原文が置かれます。</LI>

 <LI>ディレクトリ <tt>draft/</tt> には、
 「原文のコメントつき」の翻訳版が置かれます。
 ここに置かれるページは、ドラフト版・リリース版を問わず、
 常に翻訳作業の最新版になります。</LI>

 <LI>ディレクトリ <tt>release/</tt> には、
 「原文を取り去ったリリース版」が置かれます。</LI>

 <LI>ディレクトリ <tt>contrib/</tt> には、
  JM 以外で翻訳されたページの寄贈を受けた場合に、
  そのファイルが置かれます。
</UL>

<P>
 実作業との対応は
 _LINK(index.html#flow,翻訳作業の流れ)
 を参考にしてください。
</P>


<H2><A NAME="translation_list">translation_list の書式</A></H2>
<P>
 translation_list はパッケージディレクトリのルートに
 一つだけ置かれるテキストデータベースファイルで、
 そのディレクトリ以下に含まれる man ページの情報が
 一つのページにつき一行ずつ書かれています。
 フィールドの区切りはコロン (:) です。
 以下に例を示します。
 1行目が
 _LINK(#roffpage,通常のページ)
 の、 2 行目が
 _LINK(#linkpage,リンクページ)
 のそれぞれ例になっています。
</P>

<PRE>
○:LDP man-pages:1.26:1998/10/03:bind:2:1999/08/02::uv9h-hykw@asahi-net.or.jp:HAYAKAWA Hitoshi:
＠:LDP man-pages:1.26:1996/04/15:break:2:unimplemented:2:
</PRE>

<H3><A NAME="roffpage">通常のページ</A></H3>

<p>
 「通常のページ」とは、
  _LINK(#linkpage,→リンクページ)
 以外のページ、実際に文章が書かれているページを指します。
</P>
<p>
 まず第 1 フィールドの内容を説明します。
 それぞれのマークの説明に書いてある r:, d:, o: とは、
 そのマークのステータスにおいて、
 release/, draft/, original/ 各ディレクトリに
 マニュアルページが存在するかどうかを示したものです。
 _LINK(index.html#flow,翻訳作業の流れ)
 と併せてご覧ください。
</P>
<UL>
 <LI>0: ページ無し
 <LI>1: 第一世代
 <LI>2: 第二世代
</UL>
<P CLASS="noindent">
を表します。
</P>

<UL>
 <LI>？: 不明、要調査
 <LI>×: 未着手 (r:0, d:0, o:1)
 <LI>▲: 翻訳予約・作業中 (r:0, d:0, o:1)
 <LI>△: 翻訳終了。校正者募集中 (r:0, d:1, o:1)
 <LI>●: 校正中 (r:o, d:1, o:1)
</UL>

<UL>
 <LI>☆: 原文の改訂版がリリースされた。要改訂 (r:1, d:1, o:2)
 <LI>■: 改訂予約・作業中 (r:1, d:1, o:2)
 <LI>□: 改訂終了。校正者募集 (r:1, d:2, o:2)
 <LI>◆: 改訂版校正中 (r:1, d:2, o:2)
</UL>

<UL>
 <LI>○: 校正終了 (r:1, d:1, o:1 または r:2, d:2, o:2)
 <LI>◎: 校正終了。改訂版における更新予約
           (o:1, d:1, r:1 または o:2, d:2, r:2)
</UL>

<P>
 ステータスの遷移をまとめると以下のようになります。
</P>

<PRE>
未翻訳状態から:
   × → ▲ →(△)→ ● → ○
                        → ◎
オリジナル改訂後:
  (○)→ ☆ → ■ →(□) → ◆ → ○
  (◎)→ → → ↑              →(◎)
</PRE>

<P>
 なお、JM 以外のプロジェクトから寄贈を受けたページについては、
 以下のようなステータスを用います。
 なお寄贈もとの URL がわかる場合は、
 「備考」のフィールドに書いておいてください
 (コロン ":" が含まれていても大丈夫です)。
</P>
<UL>
 <LI>Ｃ: オリジナルの最新アーカイブの翻訳
 <LI>ｃ: オリジナルのアーカイブの最新版より古い版の翻訳
</UL>

<P>
 第二フィールド以下の内容は以下の通りです。
</P>

<OL START=2>
 <LI>パッケージ名。
  パッケージディレクトリ名と基本的に同じものになります。</LI>
 <LI>man ページのバージョン。
  リリース後にオリジナルが改定された場合や、
  ドラフト作成作業中にさらにオリジナルの改訂があった場合など、
  リリース版・ドラフト版・オリジナル版でバージョンが異なってしまった場合には、
  "=&gt;" で区切って記述してください。その際には
  "release=&gt;draft=&gt;original" の順にしてください。
  バージョンが同じならわざわざ分けて書かなくても OK です。
  なぜなら
  <UL>
   <LI>一番右には常にオリジナル版のバージョンが入る
   <LI>改訂作業 (☆■□◆) では、
    一番左は常にリリース版のバージョンになる。
   <LI>ドラフト版のバージョンは決してリリース版とは同じにならない。
  </UL>
  という条件を考えれば、
  どのバージョンがどの版に対応するかを決定するのは容易でしょうから。</LI>

 <LI>オリジナル man-page の日付。
  または原文が cvs に commit された日付になっていることもある。</LI>
 <LI>マニュアルファイルの basename。</LI>
 <LI>マニュアルのセクション番号。</LI>
 <LI>作業の日付。
  作業中であることを示すステータス(▲●■◆)では
  作業をする宣言をした日になり、
  それ以外のステータス（△○◎☆□）では
  翻訳ページの最終更新日にします。</LI>

 <LI>
  翻訳・再配布に関する条件。
  翻訳や配布に関する条件を著作者に確認をとったら、
  各著作権に従って以下のステータスを設定します。
  <UL>
   <LI>G: GPL2 (GNU Public License Version 2)
   <LI>B: BSD (BSD License)
   <LI>M: Misc.(翻訳、配布とも問題ないが、
    著作権に関しては GPL2、BSD のどちらでもなく
    原文を参照するなどの必要があるもの)
   <LI>N: Non commercial use only (商用での配布を禁止しているもの)
   <LI>o: 原著者に確認済 (obsolete)
  </UL>
  確認を取っていないものに関しては、以上のステータスを "()"
  で囲んでください。</LI>

 <LI>翻訳作業者のメールアドレス。</LI>
 <LI>翻訳作業者の名前 (ローマ字表記が望ましい)。</LI>
 <LI>備考など。</LI>

</OL>

<H3><A NAME="linkpage">リンクページ</A></H3>
<p>
 「リンクページ」とは、
 別のマニュアルページにシンボリックリンクされていたり、あるいは
</P>

<BLOCKQUOTE>
.so man1/hoge.1
</BLOCKQUOTE>

<P CLASS="noindent">
 のように roff 的にリンクされているページのことです。
 この種のページに対するステータス行の各フィールドは以下のようになります。
 通常の翻訳作業の際には、
 このステータスはあまり意識しないでも良いでしょう。
</P>

<P>
 なお、オリジナルではシンボリックリンクになっている場合でも、
 JM で配布する際には .so によるリンクに書き換えています。
</P>

<OL>
 <LI>ステータス
  <UL>
   <LI>※: リンク先が未翻訳・未公開 (ステータスでいうと ×▲△●)</LI>
   <LI>＠: リンク先が翻訳・公開済み (上記以外)</LI>
  </UL></LI>
 <LI>パッケージ名(リンク先と同じ)</LI>
 <LI>バージョン(リンク先と同じ)</LI>
 <LI>日付(リンク先と同じ)</LI>
 <LI>このマニュアル自体の名前</LI>
 <LI>このマニュアル自体のセクション</LI>
 <LI>リンク先の名前</LI>
 <LI>リンク先のセクション</LI>
</OL>

_CREDITS

 <P>
  <IMG SRC="../images/grey.png" WIDTH="14" ALT="* " HEIGHT="14">
  _LINK(index.html,JM 翻訳作業の手引きに戻る)
 </P>

_BACK_TO_HOME

</BODY>
</HTML>

