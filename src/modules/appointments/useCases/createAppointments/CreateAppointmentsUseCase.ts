import { Appointment } from '../../model/Appointment';
import { IAppointmentsRepository } from '../../repositories/IAppointmentsRepository';

class CreateAppointmentsUseCase {
  constructor(private appointmentsRepository: IAppointmentsRepository) {}

  async execute(data: Appointment): Promise<string | Error> {
    const date = new Date(data.patient.birthDate);
    const result = new Date().getFullYear() - date.getFullYear();
    console.log(result);
    if (!(result >= 18 && result <= 50)) {
      throw new Error('preRequisiteAppointment');
    }
    data.appointmentId = data.slotId;
    await this.appointmentsRepository.create(data);

    return data.appointmentId;
  }
}

export { CreateAppointmentsUseCase };
