SELECT DISTINCT
          (CASE WHEN AGENDA_CENTRAL.cd_prestador IS NULL THEN AGENDA_CENTRAL.cd_recurso_central ELSE AGENDA_CENTRAL.cd_prestador END) cd_prestador,
          (CASE WHEN PRESTADOR.nm_prestador IS NULL THEN (SELECT ds_recurso_central 
                                                            FROM recurso_central 
                                                          WHERE cd_recurso_central = AGENDA_CENTRAL.cd_recurso_central)
                                                  ELSE nm_prestador END) nm_prestador,
          agenda_central.cd_unidade_atendimento,

          conselho.ds_conselho, 
          conselho.cd_uf, 
          prestador.nr_documento
      FROM dbamv.agenda_central 
      LEFT JOIN dbamv.prestador ON prestador.CD_PRESTADOR = agenda_central.CD_PRESTADOR
      LEFT JOIN dbamv.conselho ON conselho.CD_CONSELHO = prestador.CD_CONSELHO