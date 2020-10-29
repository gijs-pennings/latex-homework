\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{homeworg}[2020/10/29 Gijs's homework template]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[12pt, a4paper]{article}

% load before fontenc: https://tex.stackexchange.com/a/2869
\RequirePackage{libertinus-type1}
\RequirePackage{libertinust1math}

\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}

% load early: https://tex.stackexchange.com/a/151864
\RequirePackage[american]{babel}

\RequirePackage{amsmath, amssymb, amsthm}
\RequirePackage{mathtools}
\RequirePackage{microtype}
\RequirePackage{parskip}

% load last
\RequirePackage{hyperref}
\RequirePackage[margin=1in]{geometry} % after hyperref, per user manual

% Without this patch, there is too much vertical spacing above and below the
% proof environment. I've not found other environments that suffer from this.
% This solution was chosen because it requires no additional packages. I think
% the combination of parskip and use of topsep in proof is the cause. See
% questions 192722, 339440, 522809 on https://tex.stackexchange.com
\let\@proof\proof
\renewenvironment{proof}{\begin{@proof}\unskip}{\end{@proof}\unskip}

\counterwithin{equation}{section} % reset equation counter for each section
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
        Exercise \arabic{section}%
        \ifnum#1>-1\texorpdfstring{% hide no. points from bookmark: https://tex.stackexchange.com/a/10557 (enskip produces error anyway)
            \enskip(#1 pt\ifnum#1=1\else s\fi)%
        }{}\fi%
    }%
    \setcounter{secnumdepth}{3}%
}

% TODO: why , instead of .
\newcommand*{\homeworgauthor}{G.\,P\kern-,05em.\,S.~Pennings}

\newcommand*{\N}{\mathbb N}
\newcommand*{\Z}{\mathbb Z}
\newcommand*{\Q}{\mathbb Q}
\newcommand*{\R}{\mathbb R}
\newcommand*{\C}{\mathbb C}

\let\@circ\circ
\renewcommand*{\circ}{\mathbin\@circ} % TODO: why is it so cramped in the first place?
\renewcommand*{\emptyset}{\varnothing}
\renewcommand*{\epsilon}{\varepsilon}

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
