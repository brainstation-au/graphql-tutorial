FROM node:10-alpine

ENV PORT 4000
EXPOSE 4000

COPY . /opt/code

WORKDIR /opt/code

RUN npm install && npm run build

CMD ["npm", "start"]
