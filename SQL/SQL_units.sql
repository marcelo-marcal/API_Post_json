SELECT DISTINCT(agenda_central.cd_unidade_atendimento),
          unidade_atendimento.ds_unidade_atendimento,
          multi_empresas.nr_cep,
          multi_empresas.nm_bairro,
          cidade.nm_cidade,
          multi_empresas.ds_endereco,
          multi_empresas.cd_uf,
          multi_empresas.nr_telefone_empresa,
          'PHYSICAL' Tipo 
        FROM dbamv.agenda_central
        LEFT JOIN dbamv.multi_empresas ON multi_empresas.cd_multi_empresa = agenda_central.cd_multi_empresa
        LEFT JOIN dbamv.unidade_atendimento ON unidade_atendimento.cd_unidade_atendimento = agenda_central.cd_unidade_atendimento
        LEFT JOIN dbamv.cidade ON cidade.cd_cidade = multi_empresas.cd_cidade