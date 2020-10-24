\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{homeworg}[2020/10/24 Gijs's homework template]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[12pt, a4paper]{article}

% https://tex.stackexchange.com/a/59706
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

% load last
\RequirePackage{hyperref}
\RequirePackage[margin=1in]{geometry} % after hyperref, per user manual

% replace enskip by space in bookmarks: https://tex.stackexchange.com/a/330980
% TODO: I don't know why it must be '~ ' instead of ' '
\pdfstringdefDisableCommands{\def\enskip{~ }}

% TODO: There seems to be 'double spacing' above the proof environment. I think
% parskip is to blame, and the fact that proof resets topsep? This patch seems
% to work, but I don't know why, exactly. It's probably also necessary for other
% environments (but I don't use those too often).
% https://tex.stackexchange.com/a/232659
% https://tex.stackexchange.com/a/344998 (pretocmd may be interesting)
\xpatchcmd{\proof}{\topsep6\p@\@plus6\p@\relax}{}{}{}

\newcounter{exercise}
\counterwithin{equation}{exercise} % reset 'equation' counter when 'exercise' is incremented
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
        \ifnum#1>-1%
            \enskip(#1 pt\ifnum#1=1\else s\fi)%
        \fi%
    }%
    \setcounter{secnumdepth}{3}%
}

\newcommand*{\N}{\mathbb N}
\newcommand*{\Z}{\mathbb Z}
\newcommand*{\Q}{\mathbb Q}
\newcommand*{\R}{\mathbb R}
\newcommand*{\C}{\mathbb C}

\newcommand*{\contradiction}{\lightning} % text mode
\renewcommand*{\emptyset}{\varnothing}
\renewcommand*{\epsilon}{\varepsilon}
\newcommand*{\transpose}{^\top}

% define * as \cdot: https://tex.stackexchange.com/a/563857
\mathcode`\*=\number\cdot

% https://tex.stackexchange.com/a/43009
\DeclarePairedDelimiter{\abs}{\lvert}{\rvert}
\DeclarePairedDelimiter{\ceil}{\lceil}{\rceil}
\DeclarePairedDelimiter{\floor}{\lfloor}{\rfloor}
\DeclarePairedDelimiter{\inner}{\langle}{\rangle} % bad name
\DeclarePairedDelimiter{\norm}{\lVert}{\rVert}

\let\@abs\abs
\let\@ceil\ceil
\let\@floor\floor
\let\@inner\inner
\let\@norm\norm

\def\abs{\@ifstar{\@abs}{\@abs*}}
\def\ceil{\@ifstar{\@ceil}{\@ceil*}}
\def\floor{\@ifstar{\@floor}{\@floor*}}
\def\inner{\@ifstar{\@inner}{\@inner*}}
\def\norm{\@ifstar{\@norm}{\@norm*}}

% https://gist.github.com/godbyk/1176128
\DeclareUnicodeCharacter{20AC}{\euro}
