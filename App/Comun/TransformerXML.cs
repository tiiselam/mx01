using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.Xsl;
using System.IO;

namespace Comun
{
    public class TransformerXML
    {
        private Dictionary<string, XslCompiledTransform> transforms = new Dictionary<string, XslCompiledTransform>();
        public string cadenaOriginal = "";

        public XslCompiledTransform Load(string rutaArchivoXSLT)
        {
            XslCompiledTransform transform = null;
            try
            {
                if (!transforms.TryGetValue(rutaArchivoXSLT, out transform))
                {
                    transform = new XslCompiledTransform();
                    transform.Load(rutaArchivoXSLT);
                    transforms[rutaArchivoXSLT] = transform;
                }
                return transform;
            }
            catch (Exception lo)
            {
                throw new IOException("Excepción al inicializar la plantilla de transformación de XML. Verifique la existencia del archivo: " + rutaArchivoXSLT, lo);
            }

        }

        /// <summary>
        /// Transforma el xml a cadena original
        /// </summary>
        /// <param name="archivoXml">Archivo xml a transformar.</param>
        /// <param name="transformer">Objeto que aplica un xslt al archivo xml.</param>
        /// <returns>False cuando hay al menos un error</returns>
        public void getCadenaOriginal(XmlDocument archivoXml, XslCompiledTransform transformer)
        {
            StringWriter writer = new StringWriter();
            try
            {
                transformer.Transform(archivoXml, null, writer);
                cadenaOriginal = writer.ToString();
            }
            catch 
            {
                throw;
            }
        }
    }
}
