/** Open a PDF URL in a hidden iframe and trigger the browser print dialog. */
export function printPdfInBrowser(url: string): Promise<void> {
  return fetch(url)
    .then((res) => {
      if (!res.ok) throw new Error("PDF nije dostupan.");
      return res.blob();
    })
    .then((blob) => new Promise<void>((resolve, reject) => {
      const blobUrl = URL.createObjectURL(blob);
      const iframe = document.createElement("iframe");
      iframe.style.position = "fixed";
      iframe.style.right = "0";
      iframe.style.bottom = "0";
      iframe.style.width = "0";
      iframe.style.height = "0";
      iframe.style.border = "0";
      iframe.src = blobUrl;
      iframe.onload = () => {
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
      };
      iframe.onerror = () => reject(new Error("Pregledač nije mogao da učita PDF."));
      document.body.appendChild(iframe);
    }));
}
