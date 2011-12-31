using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace accessLALP
{
    public partial class Form1 : Form
    {
        private string codeFile;
        public Form1()
        {
            InitializeComponent();
        }

        private void openToolStripMenuItem_Click(object sender, EventArgs e)
        {
            openFileDialog1.DefaultExt = "alp";
            openFileDialog1.Filter = "ALP Format|*.alp|All Files|*.*";
            openFileDialog1.FilterIndex = 1;
            openFileDialog1.FileName = string.Empty;

            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {

                if (openFileDialog1.FileName == "")
                {
                    return;
                }

                string stringExtension;
                stringExtension = System.IO.Path.GetExtension(openFileDialog1.FileName);


                if (stringExtension.ToUpper() == ".SIL")
                {
                    richTextBox1.LoadFile(openFileDialog1.FileName, RichTextBoxStreamType.RichText);
                }
                else
                {
                    System.IO.StreamReader textReader;
                    textReader = new System.IO.StreamReader(openFileDialog1.FileName);
                    richTextBox1.Text = textReader.ReadToEnd();
                    textReader.Close();
                    textReader = null;
                    richTextBox1.SelectionStart = 0;
                    richTextBox1.SelectionLength = 0;
                    toolStripStatusLabel1.Text = "File Loaded";
                }


                codeFile = openFileDialog1.FileName;


            }
            else
            {
                toolStripStatusLabel1.Text=("Cancel Invoked");
            }

        }

        private void vHDLToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (richTextBox1.Text.Length != 0)
            {
               /// System.ServiceModel.BasicHttpBinding bs = new System.ServiceModel.BasicHttpBinding();
                //bs.ReaderQuotas.MaxStringContentLength = 8192 * 120;
              

                toolStripStatusLabel1.Text = "Attempting to connect to server";
                lalpService.lalpServerClient lalp = new lalpService.lalpServerClient();
                outputTextBox.Text = lalp.vhdlGeneration(richTextBox1.Text);
                toolStripStatusLabel1.Text = "Fetched result from the server";

            }

        }
    }
}
