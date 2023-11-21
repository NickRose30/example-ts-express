FROM --platform=linux/amd64 node:18.16.1

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

EXPOSE 80

CMD ["npm", "start"]