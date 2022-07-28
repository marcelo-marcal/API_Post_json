import { Appointment } from '../../model/Appointment';
import { IAppointmentsRepository } from '../IAppointmentsRepository';
import knex from '../../../../database/db';

export class AppointmentsRepository implements IAppointmentsRepository {
  private static INSTANCE: AppointmentsRepository;

  private constructor() { }
  public static getInstance(): AppointmentsRepository {
    if (!AppointmentsRepository.INSTANCE) {
      AppointmentsRepository.INSTANCE = new AppointmentsRepository();
    }
    return AppointmentsRepository.INSTANCE;
  }

  async create(data: Appointment): Promise<void | Error> {
    console.log(data);
    try {
      // CD_AGENDAMENTO_INTEGRA > FROM dbamv.it_agenda_central
      let [result] = await knex.raw(`
      SELECT nm_paciente FROM dbamv.it_agenda_central WHERE cd_it_agenda_central = ${data.slotId}      
      `,
        // `SELECT * FROM dbamv.it_agenda_central WHERE nm_paciente IS NULL
        // AND cd_it_agenda_central = ${data.slotId}`,
      );
      console.log(result);
      if (!result) {
        throw new Error('slotNotAvailable');
      }

      [result] = await knex.raw(
        `SELECT cd_dti_agenda FROM dataintegra.tbl_dti_agendamento WHERE cd_produto = '${data.productId}' AND nr_carteira = '${data.patient.benefitCode}'`,
      );
      if (result) {
        throw new Error('forbiddenAppointment');
      }

      const seq_agenda = await knex.raw(
        `SELECT dataintegra.seq_dti_agendamento.nextval seq_dti from dual`,
      );

      console.log(seq_agenda[0].SEQ_DTI);
      const sql = `INSERT INTO dataintegra.tbl_dti_agendamento(
        cd_dti_agenda,
        tp_fluxo,
        tp_status,
        ds_erro,
        dt_gerado,
        tp_registro,
        dt_processado, 
        tp_movimento,
        cd_multi_empresa,
        ds_cancelamento,
        cd_it_agenda_central,
        CD_AGENDAMENTO_INTEGRA, 
        CD_PRESTADOR, 
        CD_UNIDADE_ATENDIMENTO, 
        CD_PRODUTO,
        SN_TELEMEDICINA, 
        NR_CARTEIRA, 
        NR_FONE, 
        EMAIL, 
        NM_PACIENTE, 
        DT_NASCIMENTO, 
        NR_CPF)        
        VALUES 
        ('${seq_agenda[0].SEQ_DTI}',
        '${(data.tp_fluxo = 'S')}',
        '${(data.tp_status = 'A')}',
        '${data.ds_erro}',
        to_Date('${new Date().toISOString().split('T')[0]}','YYYY-MM-DD'),
        '${(data.tp_registro = '001')}',
        '${data.dt_processado}',
        '${(data.tp_movimento = 'I')}',
        '${data.cd_multi_empresa}',
        '${data.reason}',
        '${data.slotId}', 
        '${data.appointmentId}',
        '${data.professionalId}', 
        '${data.unitId}', 
        '${data.productId}',
        '${data.telemedicine}',
        '${data.patient.benefitCode}', 
        '${data.patient.phone}', 
        '${data.patient.email}', 
        '${data.patient.name}', 
        to_Date('${data.patient.birthDate}','YYYY-MM-DD'), 
        '${data.patient.document.number}')
        `;
      await knex.raw(sql);

      let result_func_agenda = await knex.raw(
        `DECLARE
        P_RESULT NUMBER;
        BEGIN DATAINTEGRA.PRC_DTI_AGENDAMENTO(P_RESULT);
        DBMS_OUTPUT.put_line(P_RESULT);
          END;
        `,
      );

      // let [result2] = await knex.raw(
      //   `SELECT cd_dti_agenda FROM dataintegra.tbl_dti_agendamento WHERE CD_AGENDAMENTO_INTEGRA = ${data.slotId}`,
      // );
      // console.log(result2);
      // if (!result) {
      //   throw new Error('Não foi possivel agenda o horario!');
      // }

      console.log(result_func_agenda);
    } catch (error) {
      console.error(error);
      throw new Error(error.message);
    }
  }
}
