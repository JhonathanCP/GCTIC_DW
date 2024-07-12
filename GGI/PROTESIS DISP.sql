select 
t.solopeoricenasicod||'-'||t.solopecenasicod||' '||a.cenasidescor as "CENT.ASIS",
to_char(t.solopeprofec,'dd/mm/yyyy')            AS FECPROGRAMADA,
decode(b.persexocod, '1','M','0','F','')          as "SEXO",
(floor(months_between(sysdate,b.pernacfec)/12))   as "EDAD",
to_char(t.solopefec,'dd/mm/yyyy')                 as "FEC.SOL",
to_char(t.SolOpeProtFec,'dd/mm/yyyy')             as "FEC.DISPOS",                                     
replace(REPLACE
(trim(to_char
(substr(t.SolOpeReqProtDes,0,4000))),
CHR(10), ''), CHR(13), '')                        as "DESCRIPCION" 
from QTSOP10 t
left outer join CMCAS10 a on t.solopeoricenasicod = a.oricenasicod
                         and t.solopecenasicod    = a.cenasicod
left outer join CMPER10 b on t.solopebuspacsecnum = b.persecnum
where to_char(t.solopefec,'yyyymmdd') >= &p_fechainicio
 and to_char(t.solopefec,'yyyymmdd') <= &p_fechafin
 and t.SolOpeReqProtFlg = '1'
 and t.SolOpeTieProtFlg = '0'
 and t.EstSOpCod in ('0','4','1')
 and t.SolOpeEstRegCod  = '1'

order by t.solopeoricenasicod,t.solopecenasicod,t.solopenum;