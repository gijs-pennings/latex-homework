\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{homeworg}[2020/10/27 Gijs's homework template]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[12pt, a4paper]{article}

% font choice overview: https://tex.stackexchange.com/a/59706
% load before fontenc: https://tex.stackexchange.com/a/2869
\RequirePackage{libertine}
\RequirePackage{libertinust1math}

\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}

% load early: https://tex.stackexchange.com/a/151864
\RequirePackage[american]{babel}

\RequirePackage{amsmath, amssymb, amsthm}
\RequirePackage{enumitem}
\RequirePackage{eurosym}
\RequirePackage{graphicx}
\RequirePackage{mathtools}
\RequirePackage{microtype}
\RequirePackage{parskip}
\RequirePackage{wasysym} % for \lightning
\RequirePackage{xpatch}
\RequirePackage{xstring}

% load last
\RequirePackage{hyperref}
\RequirePackage[margin=1in]{geometry} % after hyperref, per user manual

% TODO: There seems to be 'double spacing' above the proof environment. I think
% parskip is to blame, and the fact that proof resets topsep? This patch seems
% to work, but I don't know why, exactly. It's probably also necessary for other
% environments (but I don't use those too often).
% https://tex.stackexchange.com/a/232659
% https://tex.stackexchange.com/a/344998 (pretocmd may be interesting)
\xpatchcmd{\proof}{\topsep6\p@\@plus6\p@\relax}{}{}{}

\newcounter{exercise}
\counterwithin{equation}{exercise} % reset equation counter for each exercise
\newcommand*{\exercise}{\@ifstar{%
    \@exercise%
}{%
    \ifnum\theexercise>0\newpage\fi%
    \@exercise%
}}
\newcommand*{\@exercise}[1][-1]{%
    \stepcounter{exercise}%
    \setcounter{secnumdepth}{0}% disable numbering, keeping bookmark: https://tex.stackexchange.com/a/384985
    \section{%
        Exercise \arabic{exercise}%
        \ifnum#1>-1\texorpdfstring{% hide no. points from bookmark: https://tex.stackexchange.com/a/10557 (enskip produces error anyway)
            \enskip(#1 pt\ifnum#1=1\else s\fi)%
        }{}\fi%
    }%
    \setcounter{secnumdepth}{3}%
}

\newcommand*{\name}[1]{%
    \StrSubstitute{#1}{.}{.\,}[\@var]%
    \StrSubstitute{\@var}{\, }{~}[\@var]%
    \StrSubstitute{\@var}{ }{~}%
}
\newcommand*{\homeworgauthor}{\name{G.P\kern-,1em.S. Pennings}} % TODO: why , instead of .

\newcommand*{\N}{\mathbb N}
\newcommand*{\Z}{\mathbb Z}
\newcommand*{\Q}{\mathbb Q}
\newcommand*{\R}{\mathbb R}
\newcommand*{\C}{\mathbb C}

\newcommand*{\contradiction}{\lightning} % text mode
\renewcommand*{\emptyset}{\varnothing}
\renewcommand*{\epsilon}{\varepsilon}
\newcommand*{\transpose}{^\top}

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

% https://gist.github.com/godbyk/1176128
\DeclareUnicodeCharacter{20AC}{\euro}
