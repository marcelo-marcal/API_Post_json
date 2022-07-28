import { Appointment } from '../model/Appointment';

interface IAppointmentsRepository {
  create(data: Appointment): Promise<void | Error>;
}

export { IAppointmentsRepository };
