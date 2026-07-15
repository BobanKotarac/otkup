async function readPdfBlob(res: Response): Promise<Blob> {
  if (!res.ok) throw new Error("PDF nije dostupan.");
  const blob = await res.blob();
  const header = await blob.slice(0, 5).text();
  if (!header.startsWith("%PDF-")) {
    throw new Error("Server nije vratio PDF. Restartujte aplikaciju (START-OTKUP / start.sh).");
  }
  return blob;
}

/** Open a PDF URL in a hidden iframe and trigger the browser print dialog. */
export function printPdfInBrowser(url: string): Promise<void> {
  return fetch(url)
    .then(readPdfBlob)
    .then((blob) => new Promise<void>((resolve, reject) => {
      const blobUrl = URL.createObjectURL(blob);
      const iframe = document.createElement("iframe");
      iframe.style.position = "fixed";
      iframe.style.left = "-10000px";
      iframe.style.top = "0";
      iframe.style.width = "800px";
      iframe.style.height = "600px";
      iframe.style.border = "0";
      iframe.src = blobUrl;
      iframe.onload = () => {
        window.setTimeout(() => {
          try {
            iframe.contentWindow?.focus();
            iframe.contentWindow?.print();
            resolve();
          } catch (err) {
            reject(err);
          } finally {
            window.setTimeout(() => {
              URL.revokeObjectURL(blobUrl);
              iframe.remove();
            }, 60_000);
          }
        }, 750);
      };
      iframe.onerror = () => reject(new Error("Pregledač nije mogao da učita PDF."));
      document.body.appendChild(iframe);
    }));
}
