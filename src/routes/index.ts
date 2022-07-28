import { Router } from 'express';

import { unitsRoutes } from './unitsRoutes';
import { professionalsRoutes } from './professionalsRoutes';
import { slotsRoutes } from './slotsRoutes';
import { appointmentsRoutes } from './appointmentsRoutes';
import { cancelingRoutes } from './cancelingRoutes';
import { revenuesRoutes } from './revenuesRoutes';

import { authentication } from '../middleware/authentication';

const router = Router();

router.use(authentication);

router.use('/api/v1', unitsRoutes);
router.use('/api/v1', professionalsRoutes);
router.use('/api/v1', slotsRoutes);
router.use('/api/v1', cancelingRoutes);
router.use('/api/v1', appointmentsRoutes);
router.use('/api/v1', revenuesRoutes);

export { router };
