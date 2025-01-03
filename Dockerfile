FROM node:18 as build

WORKDIR /app

# Copia i file package.json e package-lock.json
COPY package*.json ./

# Installa le dipendenze
RUN npm install

# Copia il resto dei file del progetto
COPY . .

# Costruisci l'app Angular
RUN npm run build

# Usa un'immagine Nginx per servire l'app Angular
FROM nginx:alpine

# Copia i file costruiti dall'immagine precedente
COPY --from=build /app/dist/ui-web/browser /usr/share/nginx/html

# Copia il file di configurazione Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Aggiungi un comando di debug per verificare il contenuto del file
RUN cat /etc/nginx/conf.d/default.conf

# Espone la porta 80
EXPOSE 80

# Avvia Nginx
CMD ["nginx", "-g", "daemon off;"]
