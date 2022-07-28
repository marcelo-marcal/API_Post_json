import { v4 as uuidV4 } from 'uuid';

class Appointment {
  id: string;
  cd_dti_agenda?: number;
  tp_fluxo: string;
  tp_status: string;
  ds_erro: string;
  dt_gerado: string;
  tp_registro: string;
  dt_processado: string;
  tp_movimento: string;
  cd_multi_empresa: string;
  reason: string;
  cd_agendamento_integra: string;
  appointmentId: string;
  slotId: string;
  professionalId: string;
  unitId: string;
  productId: string;
  telemedicine: string;
  patient: {
    benefitCode: string;
    phone: string;
    email: string;
    name: string;
    birthDate: Date;
    document: {
      type: string;
      number: string;
    };
  };
  constructor() {
    if (!this.id) {
      this.id = uuidV4();
    }
  }
}

export { Appointment };
