# The missing link: explaining ELF linking, semantically

## Artefact submission

This is the artefact submission for the 2016 OOPSLA SPLASH submission "The missing link: explaining ELF linking, semantically" by Kell, Mulligan, and Sewell.  There are two main components of the artefact submission: the ELF and linker formalisation in Lem itself, and the Isabelle-2016 sample proof relating to AMD64 relocation and termination proof, using a derived Isabelle version of our Lem model.  We will now detail how the artefact reviewer can assess both of these components:

### Isabelle-2016 relocation and termination proof

Checking the relocation and termination proof first requires the installation of Isabelle-2016.  The following instructions detail how this can be installed and correctly set up, ready to check our proofs:

  1. Assuming the reviewer is on Linux, download the Isabelle-2016 distribution from the official Isabelle site, or using the following direct download link: `https://isabelle.in.tum.de/dist/Isabelle2016_app.tar.gz`.  Installation instructions for Microsoft Windows and MacOS are available from the official Isabelle website, though Linux is by far the best supported platform.

  2. Extract the downloaded `tar` file into a local directory, using the following command: `tar -xzf Isabelle2016_app.tar.gz`.  This should create a new directory called `Isabelle2016`.  Add this directory to your path.

  3. The `Isabelle2016` executable should now be invokable from your terminal, if the `Isabelle2016` directory was correctly added to your path.  Invoke `Isabelle2016`.  This should open the Isabelle/jEdit interface and start building the Isabelle/HOL object logic (depending on the speed of your computer, this should take up to ten minutes).  Once the HOL object logic has been successfully built, the "build logic" popup window should disappear and a jEdit editor should be on screen.

  4. This concludes the installation of Isabelle-2016.

To check our relocation proof, do the following:

  1. Assuming our artefact submission has been extracted to `$LINKSEM_ARTEFACT`, invoke `Isabelle2016 $LINKSEM_ARTEFACT/ELF_Relocation_Proof.thy`.  This file is the top-level relocation proof theory script.  This contains both the proof of the sample theorem, discussed in our paper submission, and also imports the termination proofs, as well as (transitively) importing all Isabelle theory files derived from our Lem model.

  2. After opening the file, Isabelle2016 will ask whether the dependencies of the `ELF_Relocation_Proof` theory script should be opened.  Click "yes".  Isabelle will proceed to open and transitively check all dependencies concurrently.  Isabelle's progress can be monitored by clicking the "Theories" tab on the right hand side of the editor pane.  This can be interpreted as follows:

    a. Any red band in a theory's progress box indicates that Isabelle has encountered an error when processing that theory.  If we have correctly submitted our artefact, this should never happen.

    b. Any yellow band in a theory's progress box indicates a proof step has caused some informative message to be produced by Isabelle for the user's benefit.  This output can be safely ignored as it does not affect correctness of the proof being processed.

    c. Any purple band in a theory's progress box indicates that Isabelle is still working to check a proof step (note Isabelle is able to concurrently check theories).  Some proof steps in our proof require longer than others, though none should take longer than a minute to process.  Ultimately, Isabelle should be able to process `ELF_Relocation_Proof` and all of its dependencies within 15 minutes.

  The dependencies fall into three different classes:

    a. The Isabelle extraction of our Lem linker and ELF model,

    b. An Isabelle extraction of Anthony Fox's X86_64 model,

    c. Supporting files for Lem extracted code (i.e. the Lem standard library extracted to Isabelle).

  3. After at most 15 minutes, Isabelle should have reached the bottom of `ELF_Relocation_Proof` (i.e. there should be no purple bands in the ELF_Relocation_Proof box in the theories side-panel, nor should there be any purple lines on the right-hand side of the editor gutter when the ELF_Relocation_Proof.thy file is open) and checking the proof should be complete.  At the very bottom of the `ELF_Relocation_Proof` file is the theorem `correctness` which encodes the sample correctness property for AMD64 relocation which was mentioned in our paper submission.  For reviewers not familiar with Isabelle, the following should now be checked:

    a. The theory `Termination` provides termination proofs for the majority of our definitions in the linker and ELF model (non-recursive definitions do not require termination proofs, and some simple recursive functions can be deduced as terminating automatically).  The referee can check whether any termination proof of e.g. `foo`, is really a termination proof by typing `thm foo.simps` in the Isabelle editor pane directly after the purported termination proof.  This will display the generated simplification theorems for the function `foo`, which is only generated by Isabelle's function package after a successful termination proof.  Moving the `thm` command up before the termination proof in question will demonstrate that this is the case, as the command will now fail.

    b. No theory file contains any `axiomatization` blocks to introduce axioms into our proof scripts, nor does any file contain any `sorry` or `oops` commands to force Isabelle to accept an incomplete or faulty proof as being complete.  Our proof is completed using only Isabelle's standard datatype, definition, and recursive function packages, and all proofs are complete.

    c. The `ELF_Relocation_Proof` file contains the correctness property which we claim it does in the paper submission.  The reviewer may check the statement of correctness by examining the `correctness` definition at the top of `ELF_Relocation_Proof`.

**NOTE**: the Isabelle extraction of the linker and ELF model is derived from a slightly older version of the Lem model than is distributed in the second component of the artefact submission, due to a need to stabilise the definitions used in the proof.  We are currently working on updating the proof to use the latest version of the model, and also generalise the proof itself to work with more relocation and machine instruction types.  This was made known to the referee's during the author rebuttal period in the primary review stage.