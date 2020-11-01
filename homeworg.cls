\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{homeworg}[2020/11/01 Gijs's homework template]

% default = false
\newif\if@altquants

\DeclareOption{altquants}{\@altquantstrue} % while https://github.com/alerque/libertinus/issues/346 is not fixed
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[12pt, a4paper]{article}

% load before fontenc: https://tex.stackexchange.com/a/2869
\RequirePackage{libertinus-type1}
\RequirePackage{libertinust1math}

\if@altquants
    % https://tex.stackexchange.com/a/254626 and stix2.sty
    \DeclareFontEncoding{LS1}{}{}
    \DeclareFontSubstitution{LS1}{stix2}{m}{n}
    \DeclareSymbolFont{stix2-operators}{LS1}{stix2}{m}{n} % libertinust1math (also) defines 'operators'
    \DeclareMathSymbol{\forall} {\mathord}{stix2-operators}{"C5}
    \DeclareMathSymbol{\exists} {\mathord}{stix2-operators}{"C7}
    \DeclareMathSymbol{\nexists}{\mathord}{stix2-operators}{"C8} % TODO: not working? (amsmath?)
\fi

\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}

% load early: https://tex.stackexchange.com/a/151864
\RequirePackage[american]{babel}

\RequirePackage{aliascnt}
\RequirePackage{amsmath, amssymb, amsthm}
\RequirePackage{mathtools}
\RequirePackage{microtype}
\RequirePackage{parskip}

% load last
\RequirePackage[pdfusetitle]{hyperref} % also see 5.1 of http://mirrors.ctan.org/macros/latex/contrib/hyperref/doc/paper.pdf
\RequirePackage[margin=1in]{geometry} % after hyperref, per user manual

% Without this patch, there is too much vertical spacing above and below the
% proof environment. I've found no other environments that suffer from this,
% yet. This solution (copying & modifying the definition in amsthm.sty) was
% chosen because it requires no additional packages. I think the combination of
% parskip and the reassignment of \topsep in the original \proof is the cause.
% 192722, 339440, 522809 on https://tex.stackexchange.com
\renewenvironment{proof}[1][\proofname]{%
    \par\pushQED{\qed}\normalfont% removed: \topsep6\p@\@plus6\p@\relax
    \trivlist\item[\hskip\labelsep\itshape#1\@addpunct{.}]\ignorespaces%
}{%
    \popQED\endtrivlist\@endpefalse%
}

\providecommand{\exercisename}{Exercise}
\newcommand*{\exercise}{\@ifstar{%
    \@exercise%
}{%
    \ifnum\thesection>0\newpage\fi%
    \@exercise%
}}
\newcommand*{\@exercise}[1][-1]{%
    \setcounter{secnumdepth}{0}% disable numbering, keeping bookmark: https://tex.stackexchange.com/a/384985
    \stepcounter{section}% manually increase section counter, since ^
    \section{%
        \exercisename{} \thesection%
        \ifnum#1>-1\texorpdfstring{% hide no. points from bookmark: https://tex.stackexchange.com/a/10557 (\enskip produces error anyway)
            \enskip(#1 pt\ifnum#1=1\else s\fi)%
        }{}\fi%
    }%
    \label{ex:\thesection}%
    \setcounter{secnumdepth}{3}%
}
% \nameref is no option, since it always uses the latest \thesection
% \ref is also no option, since the sections are not actually numbered
\newcommand*{\exref}[1]{\hyperref[ex:#1]{\exercisename{} #1}}

\newcommand*{\homeworgauthor}{\texorpdfstring{%
    G.\,P\kern-,05em.\,S.~Pennings% TODO: why , instead of .
}{%
    G.P.S. Pennings%
}}

\newcommand*{\N}{\mathbb N}
\newcommand*{\Z}{\mathbb Z}
\newcommand*{\Q}{\mathbb Q}
\newcommand*{\R}{\mathbb R}
\newcommand*{\C}{\mathbb C}

\let\@circ\circ
\renewcommand*{\circ}{\mathbin\@circ} % TODO: why is it so cramped in the first place?
\renewcommand*{\emptyset}{\varnothing}
\renewcommand*{\epsilon}{\varepsilon}

\counterwithin{equation}{section} % reset equation counter for each section

\newtheoremstyle{hw-plain}{}{}{\itshape}{}{\bfseries}{ --- }{0pt}{}
\newtheoremstyle{hw-definition}{}{}{}{}{\bfseries}{ --- }{0pt}{}

% The string used by \autoref (e.g. 'Lemma') depends on the counter of the
% command. Since all theorem-type commands use the equation counter, you'd get
% the wrong string (i.e. 'Equation'). We fool hyperref by defining an alias
% counter, and we define the right string for it (e.g. \lemmaautorefname).
% https://tex.stackexchange.com/a/113540
% TODO: add \expandafter to \MakeUppercase?
\newcommand*{\NewTheorem}[1]{%
    \newaliascnt{#1}{equation}%
    \newtheorem{#1}[#1]{\MakeUppercase#1}%
    \aliascntresetthe{#1}%
    \expandafter\providecommand\csname#1autorefname\endcsname{\MakeUppercase#1}%
}

\theoremstyle{hw-plain}
\NewTheorem{lemma}
\NewTheorem{theorem}

\theoremstyle{hw-definition}
\NewTheorem{definition}

\DeclareMathOperator{\diag}{diag}

% define * as \cdot: https://tex.stackexchange.com/a/563858 and libertinust1math.sty
% use \ast for normal asterisk symbol
\DeclareMathSymbol{*}{\mathbin}{symbols}{"0C}

% https://tex.stackexchange.com/a/43009
\DeclarePairedDelimiter{\abs}{\lvert}{\rvert}
\DeclarePairedDelimiter{\ceil}{\lceil}{\rceil}
\DeclarePairedDelimiter{\floor}{\lfloor}{\rfloor}
\DeclarePairedDelimiter{\inner}{\langle}{\rangle} % bad name
\DeclarePairedDelimiter{\norm}{\lVert}{\rVert}
\DeclarePairedDelimiter{\set}{\{}{\}}
\DeclarePairedDelimiterX{\Set}[1]{\{}{\}}{\,#1\,}

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
