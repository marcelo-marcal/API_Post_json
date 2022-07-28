import { AppointmentsRepository } from '../../repositories/implementations/AppointmentsRepository';
import { CreateAppointmentsController } from './CreateAppointmentsController';
import { CreateAppointmentsUseCase } from './CreateAppointmentsUseCase';

const appointmentsRepository = AppointmentsRepository.getInstance();

const createAppointmentsUseCase = new CreateAppointmentsUseCase(
  appointmentsRepository,
);

const createAppointmentsController = new CreateAppointmentsController(
  createAppointmentsUseCase,
);

export { createAppointmentsController };
