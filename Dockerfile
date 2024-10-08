FROM node:20.17.0 AS build

WORKDIR /usr/src/app

COPY package.json yarn.lock ./

#COPY .yarn ./.yarn

RUN yarn

COPY . .

#aqui gera o diretório dist e o node_modules
RUN yarn run build

#remove dependências devDependencies
# funciona na nova versão do yarn v2
#RUN yarn workspaces focus --production && yarn cache clean

# Remove as dependências de desenvolvimento manualmente
RUN npm prune --production

FROM node:20.17.0-alpine3.20

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/yarn.lock ./yarn.lock
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
# essa pasta .yarn de release não foi gerada
#COPY --from=build /usr/src/app/.yarn ./.yarn
#COPY --from=build /usr/src/app/.yarnrc.yml ./.yarnrc.yml

EXPOSE 3000

CMD [ "yarn", "run", "start:prod" ]