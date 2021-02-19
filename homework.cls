% Copyright (c) 2020, Gijs Pennings. Licensed under the ISC license.
% For the full license, documentation, and the latest version, visit
% https://github.com/gijs-pennings/latex-homework.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{homework}[2021/02/19 Gijs's homework template]

% default = false
\newif\if@altquants
\newif\if@localnums \@localnumstrue
\newif\if@narrowmargins \@narrowmarginstrue
\newif\if@officialeuro

\DeclareOption{altquants}{\@altquantstrue} % while https://github.com/alerque/libertinus/issues/346 remains open
\DeclareOption{globalnums}{\@localnumsfalse}
\DeclareOption{officialeuro}{\@officialeurotrue}
\DeclareOption{widemargins}{\@narrowmarginsfalse}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[12pt, a4paper]{article}

% extrasp=0pt   disables extra space after sentence-ending period
% mono          disables space stretching and shrinking
% scale=.94     scales size to roughly match Libertinus's x-height
% varqu         replaces slanted by upright quotes (for code)
\RequirePackage[extrasp=0pt, mono, scale=.94, varqu]{inconsolata}

% mono=false   disables Libertinus Mono (which would replace Inconsolata)
\RequirePackage[mono=false]{libertinus-type1}

% lcgreekalpha  enables e.g. \mathbf for lower case Greek letters
\RequirePackage[lcgreekalpha]{libertinust1math}

% load fonts before fontenc: https://tex.stackexchange.com/a/2869
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}

% load early: https://tex.stackexchange.com/a/151864
\RequirePackage[american]{babel}

% Typesets the title etc. in Libertinus Display. These declarations were copied
% from ltsect.dtx and modified. Since hyperref also redefines them (to make the
% pdfusetitle option work, among others), we do it before hyperref is loaded.
% TODO: could be applied to sections as well
\DeclareRobustCommand\title[1]{\gdef\@title{\LibertinusDisplay#1}}
\DeclareRobustCommand*\author[1]{\gdef\@author{\LibertinusDisplay#1}}
\DeclareRobustCommand*\date[1]{\gdef\@date{\LibertinusDisplay#1}}
\date\today % reinitializes \date with default value, so correct font is used

\RequirePackage{aliascnt}
\RequirePackage{amsmath, amssymb, amsthm}
\RequirePackage{mathtools}
\RequirePackage{microtype}
\RequirePackage{mleftright}
\RequirePackage{parskip}
\RequirePackage{scalerel}

\if@officialeuro
    \RequirePackage[left]{eurosym}
    \let\@euro\euro
    \def\euro{\scalerel*{$\@euro$}{C}}
    \DeclareUnicodeCharacter{20AC}{\euro}
\fi

% load last
\RequirePackage[pdfusetitle]{hyperref} % 5.1 of http://mirrors.ctan.org/macros/latex/contrib/hyperref/doc/paper.pdf
\if@narrowmargins
    \RequirePackage[margin=1in]{geometry} % after hyperref, per manual
\fi

\addto\extrasamerican{
    \let\subsectionautorefname\sectionautorefname
    \let\subsubsectionautorefname\sectionautorefname
    \let\paragraphautorefname\sectionautorefname
    \let\subparagraphautorefname\sectionautorefname
}

\hypersetup{pdfcreator={LaTeX with homework}}

% \left and \right introduce extra space around the delimiters. To remove this,
% we need to insert opening (\mathopen) and closing (\mathclose) atoms. The
% package mleftright defines commands that do this automatically (\mleft and
% \mright). The command below redefines the normal \left and \right as well.
% https://tex.stackexchange.com/a/2610
\mleftright

% removes \, from all text when used for pdf fields (e.g. author)
\pdfstringdefDisableCommands{\def\,{}}

% Without this patch, there is too much vertical spacing above and below the
% proof environment. I've found no other environments that suffer from this,
% yet. This solution (copying & modifying the definition in amsthm.sty) was
% chosen because it requires no additional packages. I think the combination of
% parskip and the reassignment of \topsep in the original \proof is the cause.
% 192722, 339440, 522809 on https://tex.stackexchange.com/q/
\renewenvironment{proof}[1][\proofname]{%
    \par\pushQED{\qed}\normalfont% removed: \topsep6\p@\@plus6\p@\relax
    \trivlist\item[\hskip\labelsep\itshape#1\@addpunct{.}]\ignorespaces%
}{%
    \popQED\endtrivlist\@endpefalse%
}

\newaliascnt{exercise}{section} % so \autoref associates correct name with label
\providecommand{\exercisename}{Exercise}

\let\exercisemark\@gobble
\let\toclevel@exercise\toclevel@section % for PDF bookmarks

% disables numbering for exercises, for both actual headers and in TOC
\def\l@exercise#1#2{\begingroup\let\numberline\@gobble\l@section{#1}{#2}\endgroup} % https://tex.stackexchange.com/a/62117
\def\@nonumsexercise{}
\def\@seccntformat#1{% http://www.texfaq.org/FAQ-seccntfmt
    \ifcsname @nonums#1\endcsname\else%
        \csname the#1\endcsname\quad% default behavior for other section types, from ltsect.dtx
    \fi%
}

\newcommand*{\@exercisesection}{% copied from article.cls and modified
    \@startsection%
        {exercise}{1}{\z@}%
        {-3.5ex \@plus -1ex \@minus -.2ex}%
        {2.3ex \@plus.2ex}%
        {\normalfont\Large\bfseries}%
}
\newcommand*{\@exercise}[1][\@nil]{% https://tex.stackexchange.com/a/217763
    \def\@arg{#1}%
    \begingroup\edef\x{\endgroup% expands exercise counter for \nameref: https://tex.stackexchange.com/a/569405
        \noexpand\@exercisesection{%
            \exercisename{} % note: space
            \ifx\@arg\@nnil\the\numexpr\value{exercise}+1\else#1\fi%
        }%
    }\x%
}
\newcommand*{\exercise}{\@ifstar{%
    \@exercise%
}{%
    \ifnum\theexercise>0\newpage\fi%
    \@exercise%
}}

\newcommand*{\homeworkauthor}{\texorpdfstring{% https://tex.stackexchange.com/a/10557
    G.\,P\kern-.075em.\,S.~Pennings%
}{%
    G.P.S. Pennings%
}}

\renewcommand*{\P}{\mathbb P} % for primes or probability, overwrites shorthand for \textparagraph
\newcommand*{\N}{\mathbb N}
\newcommand*{\Z}{\mathbb Z}
\newcommand*{\Q}{\mathbb Q}
\newcommand*{\R}{\mathbb R}
\newcommand*{\C}{\mathbb C}

\if@localnums
    \counterwithin{equation}{section} % resets equation counter for each section
\fi

\newtheoremstyle{hw-plain}{}{}{\itshape}{}{\bfseries}{ --- }{0pt}{}
\newtheoremstyle{hw-definition}{}{}{}{}{\bfseries}{ --- }{0pt}{}
\newtheoremstyle{hw-remark}{}{}{}{}{\itshape}{ --- }{0pt}{} % unused

% The string used by \autoref (e.g. 'Lemma') depends on the counter of the
% command. Since all theorem-type commands use the equation counter, you'd get
% the wrong string (i.e. 'Equation'). We fool hyperref by defining an alias
% counter, and we define the right string for it (e.g. \lemmaautorefname).
% https://tex.stackexchange.com/a/113540
% TODO: add \expandafter to \MakeUppercase?
\newcommand*{\NewTheorem}[1]{%
    \expandafter\providecommand\csname#1autorefname\endcsname{\MakeUppercase#1}%
    \newaliascnt{#1}{equation}%
    \newtheorem{#1}[#1]{\MakeUppercase#1}%
    \aliascntresetthe{#1}% 1.2 of http://mirrors.ctan.org/macros/latex/contrib/oberdiek/aliascnt.pdf
}

\theoremstyle{hw-plain}
\NewTheorem{lemma}
\NewTheorem{theorem}

\theoremstyle{hw-definition}
\NewTheorem{definition}

% libertinust1math.sty
\DeclareMathSymbol{*}{\mathbin}{symbols}{"0C} % defines * as \cdot (use \ast for asterisk symbol)
\DeclareMathSymbol{\epsilon}{\libus@lcgc}{letters}{"22} % swaps definition of \epsilon ..
\DeclareMathSymbol{\varepsilon}{\libus@lcgc}{operators}{"0F} % .. and \varepsilon

% https://tex.stackexchange.com/a/254626 and fonttable package
\DeclareFontEncoding{LS1}{}{}
\DeclareFontSubstitution{LS1}{stix2}{m}{n}

\DeclareSymbolFont{stix2-symbols3}{LS1}{stix2bb}{m}{n}
\DeclareMathSymbol{\@bbone}{\mathord}{stix2-symbols3}{"31}
\def\bbone{\scalerel*{\@bbone}{1}}

% after amssymb is loaded, since it defines \nexists
\if@altquants
    \DeclareSymbolFont{stix2-operators}{LS1}{stix2}{m}{n}
    \DeclareMathSymbol{\forall} {\mathord}{stix2-operators}{"C5}
    \DeclareMathSymbol{\exists} {\mathord}{stix2-operators}{"C7}
    \DeclareMathSymbol{\nexists}{\mathord}{stix2-operators}{"C8}
\else
    \DeclareMathSymbol{\nexists}{\mathord}{operators}{"C8}
\fi

% fixes inconsistencies with libertinust1math (mathtools's conventions are used)
\renewcommand*{\vcentcolon}{\!:\!} % dirty fix: both vertical and horizontal spacing is off
\DeclareMathSymbol{\coloneqq}{\mathrel}{symbols}{"65}                   % :=
\DeclareMathSymbol{\eqqcolon}{\mathrel}{symbols}{"66}                   % =:
\renewcommand*{\coloneq}{\vcentcolon\mathrel{\mkern-1.2mu}\mathrel{-}}  % :-  (missing in Libertinus?)
\DeclareMathSymbol{\eqcolon}{\mathrel}{operators}{"EA}                  % -:

% 3.6 of http://mirrors.ctan.org/macros/latex/contrib/mathtools/mathtools.pdf
% \mid is of type \mathrel, so \; is used. In (script)script style \, is used.
% TODO: \delimsize vs \middle? add \allowbreak? \mathopen, \mathclose correct?
\newcommand*{\@renewmid}{\renewcommand*{\mid}{%
    \mathclose{}%
    \mathchoice{\;}{\;}{\,}{\,}%
    \delimsize\vert%
    \mathchoice{\;}{\;}{\,}{\,}%
    \mathopen{}%
}}

% https://tex.stackexchange.com/a/43009
\DeclarePairedDelimiter{\abs}{\lvert}{\rvert}
\DeclarePairedDelimiter{\ceil}{\lceil}{\rceil}
\DeclarePairedDelimiter{\floor}{\lfloor}{\rfloor}
\DeclarePairedDelimiter{\inner}{\langle}{\rangle} % bad name
\DeclarePairedDelimiter{\norm}{\lVert}{\rVert}
\DeclarePairedDelimiterX{\set}[1]{\{}{\}}{\@renewmid#1}
\DeclarePairedDelimiterX{\Set}[1]{\{}{\}}{\@renewmid\nonscript\,#1\nonscript\,} % \nonscript suppresses \, in (script)script style

\let\@abs\abs
\let\@ceil\ceil
\let\@floor\floor
\let\@inner\inner
\let\@norm\norm
\let\@set\set
\let\@Set\Set

\def\abs{\@ifstar{\@abs}{\@abs*}}
\def\ceil{\@ifstar{\@ceil}{\@ceil*}}
\def\floor{\@ifstar{\@floor}{\@floor*}}
\def\inner{\@ifstar{\@inner}{\@inner*}}
\def\norm{\@ifstar{\@norm}{\@norm*}}
\def\set{\@ifstar{\@set}{\@set*}}
\def\Set{\@ifstar{\@Set}{\@Set*}}
