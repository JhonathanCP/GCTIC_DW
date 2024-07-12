select r.redasisdes RED_ASIS, c.cenasides CAS, t.atenproproperfec FECHA, t.atenproactmednum ACTO_MED,
    e.arehosdescor AREA_HOS,d.servhosdes SERV_HOS,f.actdes ACTIV_HOS,
    g.pertipdocidencod TIPO_DOC_PAC,g.perdocidennum NUM_DOC_PAC,
    g.perapepatdes APE_PAT_PAC,g.perapematdes APE_MAT_PAC,g.perprinomdes PRI_NOM_PAC,
    g.persegnomdes SEG_NOM_PAC,de.atenprcpscod CPMS,pro.cpsdes DES_CPMS 
     from ctapr10 t,ctant10 a , cmcas10 c,cmras10 r,cmsho10 d,cmaho10 e, cmact10 f,  
     cmper10 g, CTAPD10 de,cmcpp10 pro where
 t.atenproestregcod='1' and  t.atenproproperfec>=to_date('01/01/2023','dd/mm/yyyy')
 and t.atenproproperfec<=to_date('31/01/2023','dd/mm/yyyy')
 and a.antpacsecnum =t.atenpropacsecnum
 and a.antcocancer=1 
 and c.oricenasicod=t.atenprooricenasicod
 and c.cenasicod = t.atenprocenasicod
 and r.redasiscod =c.redasiscod
 and e.arehoscod = t.atenproarehoscod
 and d.servhoscod = t.atenproservhoscod
 and f.actcod = t.atenproactcod
 and g.persecnum = t.atenpropacsecnum
 and de.atenprooricenasicod = t.atenprooricenasicod
 and de.atenprocenasicod = t.atenprocenasicod
 and de.atenproarehoscod = t.atenproarehoscod
 and de.atenproservhoscod = t.atenproservhoscod
 and de.atenproactcod = t.atenproactcod
 and de.atenproactespcod = t.atenproactespcod
 and de.atenprotipdocidenpercod = t.atenprotipdocidenpercod
 and de.atenproperasisdocidennum = t.atenproperasisdocidennum
 and de.atenproproperfec = t.atenproproperfec
 and de.atenproturinihor = t.atenproturinihor
 and de.atenproturfinhor = t.atenproturfinhor
 and de.atenproactmednum = t.atenproactmednum
 and pro.cpscod = de.atenprcpscod
 order by c.redasiscod,t.atenprooricenasicod,t.atenprocenasicod,t.atenproproperfec
