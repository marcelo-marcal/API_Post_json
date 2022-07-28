SELECT DISTINCT 
      dbamv.it_agenda_central.cd_agenda_central
        cd_it_agenda_central,
        agenda_central.cd_prestador,
        agenda_central.cd_unidade_atendimento,
        it_agenda_central.hr_agenda,
        'ALL' Genero 
      FROM agenda_central    
      LEFT JOIN dbamv.it_agenda_central ON it_agenda_central.cd_agenda_central= agenda_central.cd_agenda_central      
      WHERE sn_ativo = 'S'
      AND nm_paciente IS NULL
      AND it_agenda_central.hr_agenda > SYSDATE  
      AND it_agenda_central.hr_agenda BETWEEN To_Date('${date}', 'DD-MM-YYYY') AND To_Date('${onlyDate}','YYYY-MM-DD')
     ORDER BY hr_agenda ASC