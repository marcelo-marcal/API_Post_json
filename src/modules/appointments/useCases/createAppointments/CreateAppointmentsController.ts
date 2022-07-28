import { Request, Response } from 'express';

import { CreateAppointmentsUseCase } from './CreateAppointmentsUseCase';

class CreateAppointmentsController {
  constructor(private createAppointmentsUseCase: CreateAppointmentsUseCase) {}

  async handle(request: Request, response: Response): Promise<Response> {
    try {
      const appointmentId = await this.createAppointmentsUseCase.execute(
        request.body,
      );

      return response.status(201).json({ appointmentId });
    } catch (error) {
      return response.status(500).json({
        message:
          error.message ||
          'Mensagem descrevendo o erro que ocorreu em Appointment!',
      });
    }
  }
}

export { CreateAppointmentsController };
