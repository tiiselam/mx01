using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Xsl;

using Comun;
using EjecutableEncriptador;
using Encriptador;
using MaquinaDeEstados;
using QRCodeLib;

namespace cfd.FacturaElectronica
{
    public class CfdiUUID
    {
        String sopnumbe;
        String uuid;
        String sello;

        public string Sopnumbe
        {
            get
            {
                return sopnumbe;
            }

            set
            {
                sopnumbe = value;
            }
        }

        public string Uuid
        {
            get
            {
                return uuid;
            }

            set
            {
                uuid = value;
            }
        }

        public string Sello
        {
            get
            {
                return sello;
            }

            set
            {
                sello = value;
            }
        }
    }
    public class test
    {
        private Parametros _Param;
        private ConexionAFuenteDatos _Conex;
        public string ultimoMensaje = "";
        vwCfdTransaccionesDeVenta trxVenta;

        internal vwCfdTransaccionesDeVenta TrxVenta
        {
            get
            {
                return trxVenta;
            }

            set
            {
                trxVenta = value;
            }
        }

        public test(ConexionAFuenteDatos Conex, Parametros Param)
        {
            _Param = Param;
            _Conex = Conex;
        }

        /// <summary>
        /// Ejecuta la generación de archivos xml y pdf en un thread independiente
        /// </summary>
        /// <param name="e">trxVentas</param>
        public void GeneraQRCode()
        {
            try
            {
                String msj = String.Empty;
                trxVenta.Rewind();                                                          //move to first record

                int errores = 0; int i = 1;

                List<CfdiUUID> cfdi = new List<CfdiUUID>();
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000052", Uuid = "0A0661F7-BC1A-4DA7-94C2-0A153E2C65B0", Sello = "X1oRzUkOtEOFDu7XB9aslUTj1Xz5OO0bmodYEiSBGw/AXPTqCqks65gOtYTswMS9bpsLrYG8iqM0khfTrsHnlLETQ7/UfJ+et1926HxxzkgJl8YkOksljYzkvP2E1XQaRmm3+EvlGvsDY68G1OD0RC93F+z5ki6DLwEi47sT+NvVftWPmbINckyBYzOzux0P4msILsI+K/6PZIoRfZqBC3LWdDi4zKSBvMycNm+UisL/M6pNVB8R2QPKTV/zw7cZJh6Bw5oOalrJXOrmxrsKM0G7WS9eORb/h6a7pXKz2qQrQz7y78zg91sh2tRiNSsN6XZ6gNpyRlD7gsXwqhCveg==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000053", Uuid = "F182E829-D9C1-4D0E-A626-17C8FA2BF289", Sello = "fAh0RhJH+SrDq8gmGVNm1SAueKWN3visxf5VndgMCoz9Vl7YxP+H9jX6bI0Yhyah0Mw5y2wF3AvnpM4TfiK9x4T3akxC22psx82FFQyD0X5EGD87l/KDL4Yt8gEy7pr/t3+as2IHV0Dc9H7viKX5MlEzF6NBant1dQ5sI9yWy4c7Z9DCdnRyi6SYtFVseZfnh/Obe6a4vR25JkC5U/JCuywMdP1GRnKYaoc6+QXOtnBGGr4vzvYfBbtnifXD7s0L5ZaftyL8M89VXz27sxr2SongqUlAfChDN3veDFtuSYHmKNOM4aAlpy0V85Gv2ur9kgWwBMj6UxxsLpb+2QF1pA==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000054", Uuid = "681ADB71-4521-45DE-A98C-C0AB5D3186C3", Sello = "JVMNf+2deGfASIYXnjLrEo+pvmRquN7pOf/xL/2kHuLGM1yAF2m/eMputg+h4LYP+QFQ6mTEcztqdMMVQwjn6IEQMqcpWHCrVhwV/c5HcYyGOR3lcWtQX45sHA4DfKQHKaG4ZyvPVZOrnYinyWW+ZAWZ4r7QIXuFRab1Nx5QZSi/Gl8wdNbqcruFDS8mnpJKT1a+O0l2XmGYghOAxb+hk5WW512T4S6Za5DhlnoKDCQcTzM7XltB//7s3gyxsiSdUidYnDJcSCJ57rgOwOv3okCNvW2eE0HCje5zBdNS80vjytpv+UH4UfPy33kyq8Gg1N5WSCjGHcaAl6r8vAWH+A==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000055", Uuid = "2E2FDEF3-2031-4E2B-8FD4-1BB9691F5F6A", Sello = "VdTJzNLKjlpCMsnxpqe3uWCrQE8GQVryw0om06ljLp8lOTwvkUq5lizk2vXWGXqLvKI7u7N6iTkxR7A8P9rfsx4Xa4RQc0WQZmo5/L8+Ix7052asakZBokCkRM/7vyqOvpFOpEg8uCYjj7g4vzR3RtduntZ2LOXnixXdRNyxIyCOipIceqL4qK5e873G823UhkqHkYbJZghF+hrgYPQNcqhyagsTgOkjrkIrWQ0T4Sfv7hcDTYwPFyatmIE4UFFSytUuNhzZjf2dQeSOmnsIM+qdQEP63T/Z+9qR0y463YJmFcOkKfy6y27EnkFndKOOTM0cqUQrfpKJ8yHJt9K9Sw==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000770", Uuid = "B7C36DF8-DD5C-4ED1-B676-C49091E0306D", Sello = "EAJxXNgp43eqIbRVSxjY7WsLVj0EDJJIuqe+ImEf5iAkiaizGASVRiNWvcJIivpA1bBY53KNbmDRA2/298DC4LX8reE6QZ9t+WU+uz+fGMONn/W+BktC8+cr9801FLbs6iykGpvb5yIoVY4E8p7YIO80M+nJ+8M7IyAEsYfatyzAHbTlBGompiscePooTVmHU8LMqtabMmmt2XrLXhMblXffBoHMePyGYl3S2TgiMjkLljUreJ3+Sgd6iqd/tjWf5gkLbGk/EHRzRMxAjoT6XL01MCPeijD502rmRBrcJ4IBCX6PfGly37MpPF1IAn7GWdHrJE/iUw2pHs1B/YS67Q==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000771", Uuid = "C55BBD51-4053-4561-B82A-31A6D99AB1D0", Sello = "XdbhPqfXewD+uSLj0AUqmNEXdoG7PNXc8wj6uf+RVrxzGb79klIfgjG+9IP5Wc5RNXy55Ch80F50M4KefTLF2eul2pdKwsq8kEUodMh9Lb3QzaqduNl5HCF1wWJkAxBRO/4v2FsWv8Q/1VtrZos0/IyJ4XncDVTDWnEKAno7ogLcHY0f+IUS0rLR7RNBqJmV8COdNyxNFuV9E9KftSPDzd0ZeZJrNR8vcnwv0LAPhOiH+122HVjw2NDSj+FImISUz/lD04L7vPLHs4Y7wbSc1Px4EyPYrw/wLQjQ0FjQW18BicNBsmwmuy/7t6QCBM9L2r0xaFm5nzN4blUNpHzzpw==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000772", Uuid = "61B4E274-9A83-4C86-95AC-277A1805FEEB", Sello = "P0w7Y8NTuPgHIp4H/+gXnoRxZUKuOOMKM6YXBVSuo6BG9m2vqEC2MpdYX8gcj2pmUFpOOb4R3wMjzwCztUl5YbJazgthpNE9Uvyi8cub2bQC9s90zapaTl6zgQyqp1fEtSgIGEQW4QFEgoUH3xkU5VZKv9yrUXXS1TRkCnpJUkpT9RvC13ExTgFtiIHCvL/dDSU/bai/M3ucquk4UCke0IyVFz1L30lcL3akH7HyVOIr/KBJPTtQ1n0fQcbu7p/bvGDZ/UmuiQKo5cT1cUb011n/5++RgzyByLoExrE0N7EAM5xuICecnrHo03nME0gKtkpBKSlornGxwhosgxNVcQ==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000773", Uuid = "4972C124-4156-4D4B-9C37-1438C7966FB3", Sello = "GpfSh6KIHCg1fwrypWkKkjov6cMAj0W/ZGd7VDeQm4xLjfyETTZkNoZvwN1Sh6iA7Zcv01RXEFg9BR3NARDczuKh/LeEpO9cw8AEaTHFpHrEmjuiPOYKXiwKxiBEZ2PewjMb0/54+PBGqdllTDemQk3W5lvMLZeVpoSpUEDJd6SIvUwatSiIWmVy/xEG17md1NAjgqR9OeZKQ5lMOEDEat13tbeBIV1eWjcaJGPrvwZtupgBAT9hEIbQC2QknQAK9BZQml3kt1CWdfwBprOrCEcVC72FUOxDh0Wv62AOKgS3PlHvS11eceMLhqNfC0/EpuXRfDrsPchxs3YA1S91pw==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000774", Uuid = "29ADAD34-5333-404E-8B55-A584826EFFC1", Sello = "feQDwMO1c35sG1T4rMOwhxF7kUSXOzhnZaKR0J44n0TzZRWZ0yP9S6nlteQFcKB3En8QCMmOoWzlluqEQo2Cr/i2V9+f4ZJyzB09+9zUc86zAtqpkU1K5oPUE/H6UDhk4KAw/YF9vsJEW/xbL8W+Tehu2Ooqtj6n6kBjRSlCrE+ucR3EYKzrr+8wGnz5kNu5vD5O9qk/RyIKWDcahfSOuLawE+GPokvQoTU44pffYyUleHrJj3ep3o9dEjmXjDutlu+zGlakw1m9aBuqRVEDfG2ScuNJvE1HOslCTKWyJ+Rw9zDPGKD6JfROFApSJaYiGZA+Q/beOobdmM/DBW7iRg==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000775", Uuid = "13D44786-DC20-400A-84A8-7B6B05AD6681", Sello = "LDzaFlan6JMazPswDtfIGoPAYvKtBvgITEGz4fPSJFqEKRR+vwIEu/pnJLyWLMDlmD091AE5fAR0brQuzC9C/Lv8cm8Rg79wd6tTH3/alYOn1bWVM1095Czje4kuNgdF+/agACucDCRtfkd71k8izkXV8TdiwQPWxLIQsFwgnV8GFRjbQahnibI1ALTuQKapNZLHNQi/XA6dqsXX8o5Nfoao6YsWLl6+X6qtPK+dIUgrBzYcIGvRvGt/76p+86j8WPPn9jsK5uwqeCP8Z6r2XTIEp+U5adeR5j794hsAeCKt5TgJquVRwQTaoWzXOe9NNavsco49EPzHRym4hDlirg==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000776", Uuid = "52B36F59-DC09-4F95-8D4C-91F2255879BB", Sello = "hWzggPJEUESTtqLRpoUYHrieo11myjmrrJa44SDz9sw4ydfOvFgvwxnYArVG5oycWesFzUnZb7MoMWr2/GIfKfUf8yJmsaEoHVUKMJlGpf3v3D5ZRALyypHHk0cwpJnmwbRbnB9kbePQq9CE9sK7BNOwtZ5fzaYbIrrHaWlDYOwYnp4AGfNAe05JqLVKPhXcnoye7B5+Qbyv6Ss3XdrabSXOq1J543pCkT/jIMVzRQC0yC948ycZX1JFQLpmpp471RfTY4qxMPlK8Qk6gDf+uKo7LecszmcmJjn6Fy5xdieMDIv67kcMavzL/vtDRB5Z40rtmYTUywvDmoBKRl8Zlg==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000777", Uuid = "08EBA42F-EEAC-4C7A-AD33-B14E7BA077E1", Sello = "fow/bdbUzzQrmWgRoXluIMBo04GBLdpIYuFfPj0ZTZeAZZiZ1PVbPJ2r4HmvSTBsFjhOt0hqq8H/Z1YbR3hs7iXXpI30iXRKHXgrNT1pOWNblQsPw4cOZ8ine2+z+NZQkuCBytfx/2kYZ+9phQbVV+zIoDJoTGR/gUVXmjS1+0d9D3wu/PJ2Wrs+JeuXEFUaZEtcWogUlTYf0jwL0LAuDxeUstM5np0jG2cINiCUqaK1hwizegx3vCPu0D0sDSgzgyftsNh7zzKwFRoyLXmCXcnCioUO453PSBPa9vntqfBoAfSjXzGWnr1GzAWMwgcwxErWJdI9taDf1QyqDSZWug==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000778", Uuid = "02550C24-8D1B-4A93-B834-F5C8564EB308", Sello = "QQEsLLUDl12E1uA/8PcC+fYPKHAIlg4JfaGEhxxi3vDMRLWXqO+5bJFBCaPjaw4f7BVqkxREtUKKWzNIQU6RiBkrgHPV5LvluVvQqPZ/H0+EE82nhJ07/TKXfQvwq+/Cc8nNXYPjo+9EjkvjR+KTPUY5CBYRkPqhexA2QHxnWcjcKvrU0qwaYhM0LMwYc01xrSGAzerXed4ULxJqp9Gt5QnWdaF4T3OnFo05gg/UzTjRtekTHgQA+vAMU1VDUsXBrjyBi+cRJDp5iB4yhotEgHvrft7Ra75JcNrhNWjKVAJiHA2dTMFPFDolDoiU1NKVrFVhtAUYzEzvgU4P2dtSdw==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000779", Uuid = "3EF787B8-DADB-4269-A797-50327150071C", Sello = "QvTKAuOjnG361mSF4zjUuTa1dpuI837I3XOLUk9k/JlM9H71H+h6TgmxfgYcn8MQicWlc/3fwa83yrHrFNCLlonn+jY2x3psGeKiVc6g/ucdArdltTRYbHcuXDdYoKxr3r8tSvRtYERc+hShqSaBAk+KLvubf/jylz94OEN0H67DjUHL/dWVZEa5pIfBGfg2NANOc7ydysMo8fP6lMzm+FgoeVkHt90Qi2i+S4GTzC9j8ifYlBH+/FBh0JR2nsb8jDJoXLMw/c3n16VX6K2qYLNOdXNZ/hHY9LLv0JvCvvvaZuGjgrt6IPzslDqsf/bvqTIUOJg1TBs9lZIx9P3lwg==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000780", Uuid = "7E1520B1-13D9-4EBF-BEB2-67358246BC05", Sello = "cCyK9j+2MzcREL9r6ipl6q7Wz7HjRGal/BJ5MhbfcVIL24U1ONu/xkoRFH2ykEEgbPniq6xM66h+NU4ADNUoplfK5Yob7axfpwEbLlb2/Hfqb5rSJE8yOXGkXyv5hyKw2h2i92zkHCCvNxmC+5Me+BhfcrodSZokHZSm4Opvv02T9DCHeqrdO8GPR+75hM3FDxkgZ2dXJ0Tw4X/EGi7JU5Ec2CukFKzKsZc3riY0x7Se/Va3un8kk9mA/rA2XF+swDCMn0FrTf8DQtVQFZuqT3FH/vnLLK9jf6Hus6YRpBYzIzTqFYy4uD5BNutpx0e7ozzKXRdf7sTx/sbiTBkNhQ==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000781", Uuid = "2E4F4A7F-B850-4842-838C-F3951E6F39B0", Sello = "MOvW26RGSiZSJSCZijNaMRL/pOxUZw8UdY73fDbzzBCEam82macIvmn8LfvesQNIN8l2qHzSbLG5OdNGpUjVHsSkpfgulnHssfmc15CGu7bxDdF9XETST7beCuDJCNzd4pscRG+jLi/JRKE1WD8ztoJjAjAR5R/3BBKsk3lOA2XM4B+0NpzyZYHtv11HiYfib4QKnYcbZ1FDuaoI7eJUESKOotkE2hsODTySSPDgWytfdWQL9sct9zoggyvGQdHchMRpDjPGL0peBku/Pxp9oIkfS0th8eigEZ47vhGJqJkOqzIgUh1EwHPISVQMtA2GkbG3CLA4/UE/FOCJwDat5w==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000782", Uuid = "600911B3-B8F1-49F7-AE76-5CBCF3D15F5B", Sello = "LMbibEkzDGZ8OIn23P/C353GTMlZcx8V+g+sfVj34dSHn4RYygtauPyaz4XqaKNcGAyQ2p4+kjogQVNWHVpdTi4hfO2D6biwOSry+BotpjvS84+IL/fmd/bi7GQXZAigT+5rrhK3gsBKpbJQI9vg+zlRGK9WxjOMNvArxZlgkjORbth7w+zSGvEBXMUJtuRFjsIStHuz+IAd8yVpqnAe8995Hf0i5XGn9vltGl4buIKchA1hDk5Rj44Ep0Oh3kZC8eIc5Crc4UHQZF1rvsyw0L3msgQXDuYZrm2LjO2UcUCGuud33uOY3nkpwB2jmUhCYOGZEsGvYE+eOAkiVDYYRw==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000783", Uuid = "F345941F-CA20-4E33-9130-B984E7FF2E17", Sello = "MMiO7ZXe/SYdUtmCPhcrs0QCnoR26uwBt7GZ979+jk06vDd70ybDrc/Y4RcbJnsP935Ql9QQmk/BVKS3ZlzTCnI4H9Xlerb5QxrSuvecmvio/+GnAuVhVmgFN4fRzo/FASJJ/9rJQmABWw5EUdrX1I2ERrKl1vxicmiYWlijDJ8nv9OLyXgp1mMaQvlty8nh5Psfpfq5rhMMfWxfsuPA5DfnQQ7fsS7N95tlnSI7R5xvmiMHZyK9NdZ1bMXweOdu0IaQhq99SLEG2/CD/02gKNKqY1Cq9aTO9EVzeX9AwybLUP3OWtMS7Um2VeMS3z6tuN/MHdmEVx/DIf9aIynGmQ==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000784", Uuid = "E88A5388-9EBA-4B23-A040-7769F7A57C9C", Sello = "K87rBYFBobO7QrHq5/AfKcqb/JW3HH0jaEjd3iz+lAWnHqBd7FTSw8oy/ilT+TyVkOmSVQNZzheaDFQC82hM3XlzW6fdDeBgb/r4TP4V00o++20wN3ZRqi3iQgb56Yi9783hWRUnGGtmQ425cxPdox19+gEqzNy43Iueagc/zdWOzN16QVY77vHspjd4HUPCnwiFtVI37sHRven4tg9px0llwVaOO6tN1Tlx/zCG1VC0aq5x5wfEg6cLImMgT04wDrAPY+jl3uKXA5hXdehOOdGruk4B08xLU6SB93I3US2JtDuzUhkgLRQjE5xuLMtYtiRC1PwbfsDOaVDvCOk2QA==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000785", Uuid = "E380760F-F6EA-40AD-A800-EC2F7CA0D4A7", Sello = "f664+FXDnXPajlIsVX2tRTrZEwqJg9Zdov1fXZUvjvCtD0g7D8Yu/khFdda9vKsHN9rxmn59crSmj1Fcq/ewTKAfbddOXMDDAX5wsFd+Gk3FXlWiFH2tBKocWhEdDu5wuqfxetu7zPzAn7D+FqeYy05YJ6TUNkEzvzDdN/sp0zkHRkidogwe+dkENZzZ1WKklJ3DJFpVKdC1MoKcBF/9FxrL9Ktga8ucml5qMFuA9rpxCAkpdBaE/Guvd0qoTDsTZJZ56jWkHtyCdfMbrQuhM/ceW1Uxs/38xb4fc5nm7xJsERvo4qYaxA4asMHezU3d95lwdq34c0WY2ZLDjUusaQ==" });
                cfdi.Add(new CfdiUUID() { Sopnumbe = "00000786", Uuid = "FB188095-E257-462A-875D-185F74387EA2", Sello = "S5uLMkMw70I3rz7kdLHD0wHARXFiTASkNzchS0SGScmKQDolVz2tICRz/7FYbQynRo7ypIdT8yk8b5V1DJWCiiIy5mxLEBA+XBA+Ms3vPv259wi7W7qdD5OAXpcN027byeYvXexjlldw+64rN2nrBpcNe/KKgXBPrN8zKC6SoVDqRIZz5qOpMA/Fr05/5o4dYF2SBvtkC/w1lmMuQF4+lLYq4r15if40BCupcx591D8MsiF2n9uweahWdCHiONO7r4713iSpmo68NrSZ0QLi/A3O3EMyE8OnkQatpu3sJuhiOQSMr7+mAjYdMVaXslUhfYK9xEVvADeVzodbTN5DHg==" });

              do
                {
                    msj = String.Empty;
                    try
                    {
                        string nomArchivo = Utiles.FormatoNombreArchivo(trxVenta.Docid + trxVenta.Sopnumbe + "_" + trxVenta.s_CUSTNMBR, trxVenta.s_NombreCliente, 20);

                        var comp = cfdi.Where(x => x.Sopnumbe == trxVenta.Sopnumbe).First();

                        CodigoDeBarras cbb = new CodigoDeBarras();
                        cbb.GenerarQRBidimensional(_Param.URLConsulta + "?&id="+comp.Uuid+"&re=" + trxVenta.Rfc + "&rr=" + trxVenta.IdImpuestoCliente.Trim() + "&tt=" + trxVenta.Total.ToString() + "&fe="+ Utiles.Derecha(comp.Sello, 8)
                                                    , @"C:\GPUsuario\GPCfdi\feGettyMex\" + "cbb\\"+ nomArchivo + ".jpg");
                    }
                    catch (Exception lo)
                    {
                        string imsj = lo.InnerException == null ? "" : lo.InnerException.ToString();
                        msj = lo.Message + " " + imsj + Environment.NewLine;
                        errores++;
                    }
                    finally
                    {
                        //ReportProgress(i * 100 / trxVenta.RowCount, "Doc:" + trxVenta.Sopnumbe + " " + msj.Trim() + Environment.NewLine);
                        i++;
                    }
                } while (trxVenta.MoveNext() && errores < 10);
            }
            catch (Exception xw)
            {
                string imsj = xw.InnerException == null ? "" : xw.InnerException.ToString();
                this.ultimoMensaje = xw.Message + " " + imsj + "\r\n" + xw.StackTrace;
            }
            finally
            {
                //ReportProgress(100, ultimoMensaje);
            }
        }


    }
}
