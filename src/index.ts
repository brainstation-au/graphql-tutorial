// tslint:disable:no-import-side-effect
import 'reflect-metadata';
import 'source-map-support/register';

import { globalCatchOnPromiseRejection } from './util/catch-promise-rejection';
import { connectDatabase } from './database';
import { initServer } from './server';
import { bindDatabase } from './inversify/config';

globalCatchOnPromiseRejection();
connectDatabase()
  .then(bindDatabase)
  .then(initServer);