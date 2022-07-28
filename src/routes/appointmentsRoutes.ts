import { Router } from 'express';
import { createAppointmentsController } from '../modules/appointments/useCases/createAppointments';

const appointmentsRoutes = Router();

appointmentsRoutes.post('/appointments', (request, response) => {
  return createAppointmentsController.handle(request, response);
});

export { appointmentsRoutes };
