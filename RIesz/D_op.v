
Require Import HoTTClasses.interfaces.abstract_algebra
               HoTTClasses.interfaces.orders
               HoTTClasses.implementations.sierpinsky
               HoTTClasses.implementations.dedekind
               HoTTClasses.theory.rationals
               HoTTClasses.theory.premetric. 
Require Import HoTT.HSet HoTT.Basics.Trunc HProp HSet
               Types.Universe UnivalenceImpliesFunext
               TruncType UnivalenceAxiom Types.Sigma
               FunextVarieties hit.quotient. 

Require Import RoundedClosed Opens Functions 
               Valuations LowerIntegrals. 
                              
Set Implicit Arguments.

Section Dop.

Context `{Funext} `{Univalence}.

Definition D_op {A :hSet} (q : Q) : mf A -> OS A.
Proof. 
intros f z.
destruct (f z). 
refine (val rl q). 
Defined. 

Lemma D_op_correct {A:hSet}: forall f q (x:A),
    (D_op q f) x <-> QRlow q < (f x).
Proof. 
intros f q x; split; intro HH. 
+ unfold D_op in HH.
  simpl in HH. 
  destruct (f x); simpl.
  red; unfold Rllt, RCLt_l. 
  apply tr.   
  exists q. 
  split; trivial.
  unfold QRlow. 
  simpl; intros Hn. 
  unfold semi_decide in Hn. 
  destruct (decide (q < q)).
  generalize (@orders.eq_not_lt Q). 
  intros SS; specialize (SS _ _ q q). 
  apply SS. reflexivity. apply l.   
  case (not_bot Hn). 
+ unfold D_op.
  red in HH. 
  destruct (f x). 
  simpl in H.
  unfold QRlow in H. 
  unfold Rllt, RCLt_l in H. 
  revert HH; apply (Trunc_ind _); intros HH. 
  destruct HH as (s,(E1,E2)). 
  simpl in E2. 
  unfold semi_decide in E2. 
  destruct (decide (s < q)) in E2.
  case E2; apply top_greatest.  
  assert (Hsq : q <= s). 
  apply Fpo_Qle_Qlt; trivial.  
  apply RC_mon with Qle rl s.   
  intros s1 s2; apply (antisymmetry le).
  apply orders.le_or_lt. 
  apply Fpo_Qle_Qlt. 
  intros F. case (n F). 
  unfold RCLe_l; auto. 
  trivial. 
Qed. 

Lemma D_op_mon_f {A:hSet}: forall q f g,
    f <= g -> D_op q f <= @D_op A q g. 
Proof. 
intros q f g Hfg z; unfold D_op.
assert (Hle : f z <= g z).   
apply Hfg. destruct (f z). 
destruct (g z).
red in Hle.
unfold Rl_pos_Le, Rlle, RCLe_l in Hle.
apply imply_le.
exact (Hle q). 
Qed. 

Lemma D_op_mon_q {A:hSet} : forall p q f,
    p <= q -> @D_op A q f <= @D_op A p f. 
Proof. 
intros p q f Hpq.
assert (Haux : forall z, D_op q f z -> D_op p f z).   
intros z. intros Hq. 
apply D_op_correct. 
apply D_op_correct in Hq. 
red; red in Hq. 
unfold Rllt, RCLt_l in *.  
revert Hq; apply (Trunc_ind _). 
intros Hq; apply tr. 
destruct Hq as (s,(Hq1,Hq2)). 
exists s; split. 
+ trivial. 
+ intros Ho. apply Hq2. 
  apply RC_mon with Qle (QRlow p) s. 
  intros x y; apply (antisymmetry le). 
  apply orders.le_or_lt. 
  reflexivity. unfold RCLe_l. 
  intros v Hv. 
  unfold QRlow. simpl in *. 
  unfold semi_decide in *. 
  destruct (decide (v < q)). 
  apply top_greatest. 
  destruct (decide (v < p)). 
  assert (Hr : v < q). 
  apply orders.lt_le_trans with p; try trivial. 
  case (n Hr). 
  trivial. trivial.
+ intros z; apply imply_le; exact (Haux z). 
Qed.

End Dop. 
