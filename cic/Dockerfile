# Stage 1: Build
FROM node:20-alpine AS builder

# Cài thêm curl (nếu muốn debug trong stage build)
RUN apk add --no-cache curl

WORKDIR /usr/src/app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
RUN yarn build

# Stage 2: Runtime
FROM node:20-alpine

# Cài curl ở runtime
RUN apk add --no-cache curl

WORKDIR /usr/src/app

COPY package.json yarn.lock ./
RUN yarn install 
COPY --from=builder /usr/src/app/dist ./dist
# COPY --from=builder /usr/src/app/public ./public

EXPOSE 3000
CMD ["node", "dist/main.js"]
