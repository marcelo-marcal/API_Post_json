PROMPT CREATE TABLE dataintegra.tbl_dti_agendamento
CREATE TABLE dataintegra.tbl_dti_agendamento (
  cd_dti_agenda          NUMBER(38,0)   NOT NULL,
  tp_fluxo               VARCHAR2(1)    NULL,
  tp_status              VARCHAR2(1)    NOT NULL,
  ds_erro                VARCHAR2(4000) NULL,
  dt_gerado              DATE           NULL,
  tp_registro            VARCHAR2(3)    NULL,
  dt_processado          VARCHAR2(4000) NULL,
  tp_movimento           VARCHAR2(4000) NULL,
  cd_multi_empresa       VARCHAR2(4000) NULL,
  cd_registro_principal  VARCHAR2(4000) NULL,
  cd_registro_pai        VARCHAR2(4000) NULL,
  cd_registro_filho      VARCHAR2(4000) NULL,
  dt_agenda              VARCHAR2(4000) NULL,
  hr_inicio              VARCHAR2(4000) NULL,
  ds_cancelamento        VARCHAR2(4000) NULL,
  cd_it_agenda_central   VARCHAR2(4000) NULL,
  cd_agendamento_integra VARCHAR2(4000) NULL,
  cd_prestador           VARCHAR2(4000) NULL,
  cd_unidade_atendimento VARCHAR2(4000) NULL,
  cd_item_agendamento    VARCHAR2(4000) NULL,
  cd_setor               VARCHAR2(4000) NULL,
  cd_produto             VARCHAR2(4000) NULL,
  nr_carteira            VARCHAR2(4000) NULL,
  nr_fone                VARCHAR2(4000) NULL,
  email                  VARCHAR2(4000) NULL,
  nm_paciente            VARCHAR2(4000) NULL,
  cd_convenio            VARCHAR2(4000) NULL,
  dt_nascimento          DATE           NULL,
  nr_cpf                 VARCHAR2(4000) NULL,
  sn_telemedicina        VARCHAR2(4000) NULL
)
  STORAGE (
    NEXT       1024 K
  )
/