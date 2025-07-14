FROM node:18-alpine AS builder
 
WORKDIR /app
COPY . .
 
## The `BUILDTIME_ENV_EXAMPLE` here will be set before building automatically
ARG BUILDTIME_ENV_EXAMPLE
ENV BUILDTIME_ENV_EXAMPLE=${BUILDTIME_ENV_EXAMPLE}
 
RUN npm install && \
    npm run build
 
FROM nginx:alpine
 
COPY nginx.conf /etc/nginx/conf.d/configfile.template
COPY --from=builder /app/dist /usr/share/nginx/html
 
ENV \
    PORT=8080 \
    HOST=0.0.0.0
 
EXPOSE 8080
 
CMD sh -c "envsubst '\$PORT' < /etc/nginx/conf.d/configfile.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
