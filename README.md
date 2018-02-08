A Fork of CoqHammer version 1.0.6 for Coq 8.7 and 8.7.1

COPYRIGHT AND LICENSE
---------------------

Copyright (c) 2017-2018, Lukasz Czajka and Cezary Kaliszyk, University of Innsbruck
Distributed under the terms of LGPL 2.1, see the file "LICENSE".

INSTALLATION
------------

If Coq 8.7 is already installed, build and install the plugin by running:

```
make
make install
```

To use the hammer you will also need some automated provers
installed. More information about provers is provided below.

The plugin has been tested on Linux and MacOS X. On MacOS X you need
grep available in the path. You also need the GNU C and C++
compilers (gcc and g++) available in the path for installation to
succeed.

The command 'make install' will try to install the 'predict' program
into the directory specified by the COQBIN environment variable. If
this variable is not set then a binary directory is guessed basing
on the Coq library directory.

Note that some old versions of ProofGeneral encounter problems with
the plugin. If you use ProofGeneral you might need the most recent
version obtained directly from https://proofgeneral.github.io.

USAGE
-----

In `coqtop` or `coqide`, first load the hammer plugin:

```coq
From Hammer Require Import Hammer.
```

Then the available commands are as follows.

command                          | description
-------------------------------- | ------------------------------------
`hammer`                         |  Runs the hammer tactic.
`Hammer_cleanup`                 |  Resets the hammer cache.
`Hammer_export Dir "dir"`        |  Exports all visible objects to dir.
`Hammer_version`                 |  Prints the version of CoqHammer.

More actual examples are given in the `examples` directory.

The intended use of the `hammer` tactic is to replace it upon
success with the reconstruction tactic shown in the response
window. This reconstruction tactic has no time limits and makes no
calls to external ATPs. The success of the "hammer" tactic itself is
not guaranteed to be reproducible.

INSTALLATION OF FIRST ORDER PROVERS
-----------------------------------

To use the plugin you need at least one of the following ATPs
available in the path: Eprover (eprover), Vampire (vampire), Z3
(z3_tptp). It is recommended to have all three ATPs.

Eprover may be downloaded from http://www.eprover.org.
Vampire may be obtained from http://www.vprover.org.
Z3 may be downloaded from https://github.com/Z3Prover/z3/releases.

Note that the default version of Z3 does not support the TPTP format.
You need to compile a TPTP frontend located in examples/tptp in
the Z3 source package.

TACTICS
-------

The Reconstr module contains the reconstruction tactics which may
also be used directly in your proof scripts. In contrast to the
"hammer" tactic they do not invoke external ATPs, they do not know
anything about accessible lemmas (you need to add any necessary
lemmas to the context with "generalize" or "pose"), and they never
unfold any constants except basic logical operators (if necessary
you need to unfold constants manually beforehand). To be able to
directly use these tactics type:

```coq
From Hammer Require Import Reconstr.
```

The most useful tactics are:

- `sauto`

  A "super" version of `intuition`/`auto`. Tries to simplify the goal and
  possibly solve it. Does not perform much of actual proof search
  (beyond what "intuition" already does). It is designed in such a way
  as to terminate in a short time in most circumstances. It is
  possible to customize this tactic by adding rewrite hints to the
  yhints database.

  WARNING: This tactic may change the proof state unpredictably and
  introduce randomly named hypotheses into the context.

  It is nonetheless useful to sometimes use "sauto" before a call to
  "hammer". Then the list of hypotheses in the reconstruction tactic
  may usually be replaced by Reconstr.AllHyps, removing any dependence
  on auto-generated hypothesis names. Examples of this are provided in
  examples/imp.v and examples/combs.v.

- `ycrush`

  Tries various heuristics and performs some limited proof
  search. Usually stronger than sauto, but may take a long time if it
  cannot find a proof. In contrast to sauto, ycrush does not perform
  rewriting with rewrite hints in the yhints database. One commonly
  uses ycrush after sauto for goals which sauto could not solve.

- `yelles n`

  Performs proof search up to depth n. May be very slow for n larger
  than 3-4.

- `scrush`

  Essentially, a combination of `sauto` and `ycrush`.

- `blast`

  This tactic instantiates some universally quantified hypotheses,
  calls sauto, performs shallow proof search, and repeats the whole
  process with new instantiations. The tactic will loop if it cannot
  solve the goal.

FURTHER COQ HAMMER OPTIONS
--------------------------

```coq
Set/Unset Hammer Debug.
Set Hammer GSMode n.
(* The hammer may operate in one of two modes: gs-mode or the ordinary
   mode. If GSMode is set to n > 0 then n best strategies (combination
   of prover, prediction method and number of predictions) are run in
   parallel. Otherwise, if n = 0, then the ordinary mode is active and
   the number of machine-learning dependency predictions, the
   prediction method and whether to run the ATPs in parallel are
   determined by the options below (Hammer Predictions, Hammer
   PredictMethod and Hammer Parallel). It is advisable to set GSMode
   to the number of cores your machine has, plus/minus one. Default: 8 *)
Set Hammer Predictions n.
(* number of predictions for machine-learning dependency prediction;
   irrelevant if GSMode > 0; default: 1024 *)
Set Hammer PredictMethod "knn"/"nbayes".
(* irrelevant if GSMode > 0; default: "knn" *)
Set/Unset Hammer Parallel.
(* run ATPs in parallel; irrelevant if GSMode > 0; default: on *)
Set Hammer ATPLimit n.
(* ATP time limit in seconds, default: 15s *)
Set Hammer ReconstrLimit n.
(* base time limit for proof reconstruction (time limit for each
   tactic depends on it), default: 5s *)
Set Hammer CrushLimit n.
(* before invoking external ATPs the hammer first tries to solve the
   goal using a crush-like tactic with a time limit of n seconds; default: 1s *)
Set/Unset Hammer Eprover/Vampire/Z3.
Set Hammer PredictPath "/path/to/predict". (* default: "predict" *)
Set/Unset Hammer FilterProgram.
(* ignore dependencies from Coq.Program.*, default: on *)
Set/Unset Hammer FilterClasses.
(* ignore dependencies from Coq.Classes.*, default: on *)
Set/Unset Hammer FilterHurkens.
(* ignore dependencies from Coq.Logic.Hurkens.*, default: on *)
Set Hammer MaxATPPredictions n.
(* maximum number of predictions returned by an ATP, default: 16 *)
Set/Unset Hammer SearchBlacklist.
(* ignore dependencies blacklisted with the Search Blacklist
   vernacular command, default: on *)
Set/Unset Hammer ClosureGuards.
(* should guards be generated for types of free variables? setting
   this to "on" will typically harm the hammer success rate, but it
   may help with functional extensionality; set this to "on" if you
   use functional extensionality and get many unreconstructible
   proofs; default: off *)
```

BUGS
----

In case you encounter any bugs, report them to:
lukaszcz@mimuw.edu.pl. Include a minimal reproducible example of the
bug.

KNOWN BUGS
----------

Occasionally, the hammer tactic hangs or outputs a wrong
reconstruction tactic. The authors believe that this is due to an
error in Coq's `timeout` tactical.
