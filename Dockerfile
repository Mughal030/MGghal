FROM kalilinux/kali-rolling

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Copy the keyboard configuration script into the image
COPY configure-keyboard.sh /usr/local/bin/configure-keyboard.sh

# Make the script executable
RUN chmod +x /usr/local/bin/configure-keyboard.sh

# Install necessary packages including debconf-utils for preconfiguration
RUN apt-get update && apt-get install -y \
    debconf-utils \
    kali-linux-default \
    kali-tools-top10 \
    kali-linux-headless \
    tightvncserver \
    novnc \
    websockify \
    keyboard-configuration \
    && apt-get clean

# Run the keyboard configuration script
RUN /usr/local/bin/configure-keyboard.sh

# Set the locale
ENV LANG C.UTF-8

# Expose the VNC port
EXPOSE 5901

# Start the VNC server and noVNC
CMD ["sh", "-c", "vncserver :1 -geometry 1280x800 -depth 24 && websockify -D --web /usr/share/novnc/ --cert /etc/ssl/novnc.pem 5901 localhost:5901"]
