% Copyright (c) 2022, Gijs Pennings. Licensed under the ISC license.
% For the full license, documentation, and the latest version, visit
% github.com/gijs-pennings/latex-homework.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{homework}[2022/09/14 Gijs's homework template]


% --------[ OPTIONS ]-----------------------------------------------------------

% default = false
\newif\if@altquants
\newif\if@localnums \@localnumstrue
\newif\if@narrowmargins \@narrowmarginstrue
\newif\if@officialeuro

\DeclareOption{altquants}{\@altquantstrue} % while github.com/alerque/libertinus/issues/346 remains open
\DeclareOption{globalnums}{\@localnumsfalse}
\DeclareOption{officialeuro}{\@officialeurotrue}
\DeclareOption{widemargins}{\@narrowmarginsfalse}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[12pt]{article}


% --------[ PACKAGES: FONTS ]---------------------------------------------------

% extrasp=0pt          disables extra space after sentence-ending period
% mono                 disables space stretching and shrinking
% scale=.94            scales size to roughly match Libertinus's x-height
% varqu                replaces slanted by upright quotes (for code)
\RequirePackage[extrasp=0pt, mono, scale=.94, varqu]{inconsolata}

% mono=false           disables Libertinus Mono (would replace Inconsolata)
\RequirePackage[mono=false]{libertinus-type1}

% amsthm               loads amsthm package (in addition to amsmath)
% lcgreekalpha         enables e.g. \mathbf for lower case Greek letters
% subscriptcorrection  improves kerning of 'j' and others in subscripts
\RequirePackage[amsthm, lcgreekalpha, subscriptcorrection]{libertinust1math}

% (using tex.stackexchange.com/a/254626 and fonttable package)
\DeclareFontEncoding{LS1}{}{}
\DeclareFontSubstitution{LS1}{stix2}{m}{n}
\DeclareSymbolFont{stix2-operators}{LS1}{stix2}{m}{n}
\DeclareSymbolFont{stix2-symbols3}{LS1}{stix2bb}{m}{n}

% load fonts before fontenc: tex.stackexchange.com/a/2869
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}

% Typesets the title etc. in Libertinus Display. These declarations were copied
% from ltsect.dtx and modified. Since hyperref also redefines them (to make the
% pdfusetitle option work, among others), we do it before hyperref is loaded.
% TODO: could be applied to sections as well
\DeclareRobustCommand\title[1]{\gdef\@title{\LibertinusDisplay#1}}
\DeclareRobustCommand*\author[1]{\gdef\@author{\LibertinusDisplay#1}}
\DeclareRobustCommand*\date[1]{\gdef\@date{\LibertinusDisplay#1}}
\date\today % reinitializes \date with default value, so correct font is used


% --------[ PACKAGES: LANGUAGE ]------------------------------------------------

% load early: tex.stackexchange.com/a/151864
\RequirePackage[american]{babel}


% --------[ PACKAGES: MATH ]----------------------------------------------------

\RequirePackage{mathtools}
\RequirePackage{mleftright}

% \left and \right introduce extra space around the delimiters. To remove this,
% we need to insert opening (\mathopen) and closing (\mathclose) atoms. The
% package mleftright defines commands that do this automatically (\mleft and
% \mright). The command below redefines the normal \left and \right as well.
% tex.stackexchange.com/a/2610
\mleftright


% --------[ PACKAGES: OTHER ]---------------------------------------------------

\RequirePackage[a4paper]{geometry}  % to set margins etc.
\RequirePackage{aliascnt}           % to fix autoref labels for shared counters
\RequirePackage{graphicx}           % to add images and scale text
\RequirePackage{microtype}          % improves typography
\RequirePackage[parfill]{parskip}   % separates paragraphs by white space
\RequirePackage{xurl}               % allows URLs to break (almost) anywhere

\if@officialeuro
    \RequirePackage[left]{eurosym}
    \let\@euro\euro
    \def\euro{\raisebox{.0027em}{\scalebox{.87}{\@euro}}}
    \DeclareUnicodeCharacter{20AC}{\euro}
\fi

\if@narrowmargins
    \geometry{margin=1in}
\fi


% --------[ PACKAGES: HYPERREF ]------------------------------------------------

% load last: tex.stackexchange.com/q/1863
% .. and even later: mirrors.ctan.org/macros/latex/contrib/hyperref/doc/hyperref-doc.html#x1-540009
\RequirePackage[pdfusetitle]{hyperref}
\RequirePackage{ellipsis}           % fixes space after \textellipsis

% renames subsection labels (etc.) to 'section' for \autoref
\addto\extrasamerican{
    \let\subsectionautorefname\sectionautorefname
    \let\subsubsectionautorefname\sectionautorefname
    \let\paragraphautorefname\sectionautorefname
    \let\subparagraphautorefname\sectionautorefname
}

% removes boxes around links and sets Creator field
\hypersetup{
    hidelinks,
    pdfcreator={LaTeX with homework.cls}
}

% removes \, from all text when used for pdf fields (e.g. author)
\pdfstringdefDisableCommands{\def\,{}}

% customizes space between dots to recreate Libertinus's ellipsis
\renewcommand{\ellipsisgap}{.045em}


% --------[ PATCHES ]-----------------------------------------------------------

% fixes inconsistencies with libertinust1math (mathtools's conventions are used)
\renewcommand{\vcentcolon}{\!:\!}                                       % both vertical and horizontal spacing is off!
\DeclareMathSymbol{\coloneqq}{\mathrel}{symbols}{"65}                   % :=
\DeclareMathSymbol{\eqqcolon}{\mathrel}{symbols}{"66}                   % =:
\renewcommand{\coloneq}{\vcentcolon\mathrel{\mkern-1.2mu}\mathrel{-}}   % :-  (missing in Libertinus)
\DeclareMathSymbol{\eqcolon}{\mathrel}{operators}{"EA}                  % -:

% Without this patch, there is too much vertical spacing above and below the
% proof environment. I've found no other environments that suffer from this,
% yet. This solution (copying & modifying the definition in amsthm.sty) was
% chosen because it requires no additional packages. I think the combination of
% parskip and the reassignment of \topsep in the original \proof is the cause.
% 192722, 339440, 522809 on tex.stackexchange.com/q/
\renewenvironment{proof}[1][\proofname]{%
    \par\pushQED{\qed}\normalfont% removed: \topsep6\p@\@plus6\p@\relax
    \trivlist\item[\hskip\labelsep\itshape#1\@addpunct{.}]\ignorespaces%
}{%
    \popQED\endtrivlist\@endpefalse%
}


% --------[ CHARACTERS ]--------------------------------------------------------

% defines * as \cdot (use \ast for asterisk symbol)
\DeclareMathSymbol{*}{\mathbin}{symbols}{"0C}

% swaps definition of \epsilon and \varepsilon
\DeclareMathSymbol{\epsilon}{\libus@lcgc}{letters}{"22}
\DeclareMathSymbol{\varepsilon}{\libus@lcgc}{operators}{"0F}

% imports blackboard 1 from STIX (missing in Libertinus)
\DeclareMathSymbol{\@bbone}{\mathord}{stix2-symbols3}{"31}
\def\bbone{\scalebox{.93}{$\@bbone$}}

\if@altquants
    \DeclareMathSymbol{\forall} {\mathord}{stix2-operators}{"C5}
    \DeclareMathSymbol{\exists} {\mathord}{stix2-operators}{"C7}
    \DeclareMathSymbol{\nexists}{\mathord}{stix2-operators}{"C8}
\fi


% --------[ EXERCISES ]---------------------------------------------------------

\newaliascnt{exercise}{section} % so \autoref associates correct name with label
\providecommand{\exercisename}{Exercise}

\let\exercisemark\@gobble
\let\toclevel@exercise\toclevel@section % for PDF bookmarks

% disables numbering for exercises, for both actual headers and in TOC
\def\l@exercise#1#2{\begingroup\let\numberline\@gobble\l@section{#1}{#2}\endgroup} % tex.stackexchange.com/a/62117
\def\@nonumsexercise{}
\def\@seccntformat#1{% www.texfaq.org/FAQ-seccntfmt
    \ifcsname @nonums#1\endcsname\else%
        \csname the#1\endcsname\quad% default behavior for other section types, from ltsect.dtx
    \fi%
}

\newcommand{\@exercisesection}{% copied from article.cls and modified
    \@startsection%
        {exercise}{1}{\z@}%
        {-3.5ex \@plus -1ex \@minus -.2ex}%
        {2.3ex \@plus.2ex}%
        {\normalfont\Large\bfseries}%
}
\newcommand*{\@exercise}[1][\@nil]{% tex.stackexchange.com/a/217763
    \def\@arg{#1}%
    \begingroup\edef\x{\endgroup% expands exercise counter for \nameref: tex.stackexchange.com/a/569405
        \noexpand\@exercisesection{%
            \exercisename{} % note: space
            \ifx\@arg\@nnil\the\numexpr\value{exercise}+1\else#1\fi%
        }%
    }\x%
}
\newcommand{\exercise}{\@ifstar{%
    \@exercise%
}{%
    \ifnum\theexercise>0\newpage\fi%
    \@exercise%
}}

\if@localnums
    \counterwithin{equation}{section} % resets equation counter for each section/exercise
\fi


% --------[ THEOREMS ]----------------------------------------------------------

\newtheoremstyle{hw-plain}{}{}{\itshape}{}{\bfseries}{ --- }{0pt}{}
\newtheoremstyle{hw-definition}{}{}{}{}{\bfseries}{ --- }{0pt}{}
\newtheoremstyle{hw-remark}{}{}{}{}{\itshape}{ --- }{0pt}{} % unused

% The string used by \autoref (e.g. 'Lemma') depends on the counter of the
% command. Since all theorem-type commands use the equation counter, you'd get
% the wrong string (i.e. 'Equation'). We fool hyperref by defining an alias
% counter, and we define the right string for it (e.g. \lemmaautorefname).
% tex.stackexchange.com/a/113540
% TODO: add \expandafter to \MakeUppercase?
\newcommand*{\NewTheorem}[1]{
    \expandafter\providecommand\csname#1autorefname\endcsname{\MakeUppercase#1}
    \newaliascnt{#1}{equation}
    \newtheorem{#1}[#1]{\MakeUppercase#1}
    \newtheorem*{#1*}{\MakeUppercase#1}
    \aliascntresetthe{#1} % 1.2 of mirrors.ctan.org/macros/latex/contrib/oberdiek/aliascnt.pdf
}

\theoremstyle{hw-plain}
\NewTheorem{corollary}
\NewTheorem{lemma}
\NewTheorem{proposition}
\NewTheorem{theorem}

\theoremstyle{hw-definition}
\NewTheorem{definition}


% --------[ MACROS: DELIMITERS ]------------------------------------------------

% 3.6 of mirrors.ctan.org/macros/latex/contrib/mathtools/mathtools.pdf
% \mid is of type \mathrel, so \; is used. In (script)script style \, is used.
% TODO: \delimsize vs \middle? add \allowbreak? \mathopen, \mathclose correct?
\newcommand{\@renewmid}{\renewcommand{\mid}{%
    \mathclose{}%
    \mathchoice{\;}{\;}{\,}{\,}%
    \delimsize\vert%
    \mathchoice{\;}{\;}{\,}{\,}%
    \mathopen{}%
}}

% tex.stackexchange.com/a/43009
\DeclarePairedDelimiter{\@abs}{\lvert}{\rvert}
\DeclarePairedDelimiter{\@ceil}{\lceil}{\rceil}
\DeclarePairedDelimiter{\@floor}{\lfloor}{\rfloor}
\DeclarePairedDelimiter{\@inner}{\langle}{\rangle} % bad name
\DeclarePairedDelimiter{\@norm}{\lVert}{\rVert}
\DeclarePairedDelimiterX{\@set}[1]{\{}{\}}{\@renewmid#1}
\DeclarePairedDelimiterX{\@Set}[1]{\{}{\}}{\@renewmid\nonscript\,#1\nonscript\,} % \nonscript suppresses \, in (script)script style

\def\abs{\@ifstar{\@abs}{\@abs*}}
\def\ceil{\@ifstar{\@ceil}{\@ceil*}}
\def\floor{\@ifstar{\@floor}{\@floor*}}
\def\inner{\@ifstar{\@inner}{\@inner*}}
\def\norm{\@ifstar{\@norm}{\@norm*}}
\def\set{\@ifstar{\@set}{\@set*}}
\def\Set{\@ifstar{\@Set}{\@Set*}}


% --------[ MACROS: OTHER ]-----------------------------------------------------

\newcommand{\homeworkauthor}{\texorpdfstring{% tex.stackexchange.com/a/10557
    G.\,P\kern-.075em.\,S.~Pennings%
}{%
    G.P.S. Pennings%
}}

% tex.stackexchange.com/a/42728
\newcommand*{\numberthis}[1]{\stepcounter{equation}\tag{\theequation}\label{#1}}

\newcommand{\N}{\mathbb N}
\newcommand{\Z}{\mathbb Z}
\newcommand{\Q}{\mathbb Q}
\newcommand{\R}{\mathbb R}
\newcommand{\C}{\mathbb C}
