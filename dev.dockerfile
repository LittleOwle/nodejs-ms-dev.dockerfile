FROM node:20.15-alpine AS base

LABEL authors="Jamil Services <jamilservices@gmail.com>"

ENV NODE_ENV=development

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

WORKDIR /nats

RUN apk update && apk --no-cache add --no-cache gcompat libstdc++

RUN corepack enable

WORKDIR /app
  
COPY --chown=node:node package.json pnpm-lock.* ./

FROM base AS dev-deps
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile

FROM base

COPY --chown=node:node --from=dev-deps /app/node_modules /app/node_modules
COPY --chown=node:node . .

USER node

CMD [ "pnpm", "dev" ]
