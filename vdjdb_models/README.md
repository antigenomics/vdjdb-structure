### Mutator paper scripts

This folder contains scripts post-analysis of modeled TCR-pMHC complexes for VDJdb records. For the actual settings and workflow used for modelling please refer to ``rosetta/`` folder.

This folder also contains the "pathways" file ``neighbors.mut_v_3aa_mhc_tcr_cdr3_HM_ONLY_same_pept_sorted_2022_04.txt`` indicating mutations to introduce in template PDB files and their order. It has the following columns: 

1. pdb.id: Original template PDB 
2. chain.id: Chain name in the  original template PDB carrying the substitution
3. residue.index: Residue index to substitute
4. gene: TRA/TRB chains
5. cdr3.from: Sequence of the CDR3 loops before substitution 
6. cdr3.to: Sequence of the CDR3 loops after the substitution 
7. species: Organism
8. antigen.epitope.from: Sequence of the epitope in the initial complex (VDJdb)
9. v.segm.from: V-segment of TCR in the initial complex (VDJdb)
10. j.segm.from: J-segment of TCR in the initial complex (VDJdb)
11. v.segm.to: V-segment of TCR in the modeled complex (VDJdb)
12. j.segm.to: J-segment of TCR in the modeled complex (VDJdb)
13. antigen.epitope.to: Sequence of the epitope in the modeled complex (VDJdb)
14. hm: Hamming distance between *cdr3.from* and *cdr3.to* sequences 
15. order: Number of sequential substitutions introduced to the original template PDB ÒMutaion orderÓ
16. v.segm2: Selected V-segment from multiple variations of *v.segm.to*
17. aa.from: Initial amino acid (1 letter)
18. aa.to: New amino acid (1 letter)
19. aa.pos: Position of the substitution in the CDR3 loop 
20. region.start: Start of the CDR3 loop
21. residue.index.pdb: Number of substituted amino acid residue according to the PDB numeration.
22. residue.ins.code: Insertion instead of the substitution (empty)
23. aa.from.3: Initial amino acid (3 letters)
24. aa.to.3: New amino acid (3 letters)
25. MHCa.chain: Chain in the Original template PDB carrying MHCa
26. MHCb.chain: Chain in the Original template PDB carrying MHCb
27. TRA.chain: Chain in the Original template PDB carrying TCR
28. TRB.chain: Chain in the Original template PDB carrying peptide
29. pept.chain: Chain in the Original template PDB carrying peptide
30. cdr3.TRA.template: Sequence of the CDR3? in the Original template PDB
31. cdr3.TRB.template: Sequence of the CDR3? in the Original template PDB





