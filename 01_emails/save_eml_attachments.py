import email
import os

#1 . change this to the folder where the .eml files are (change the part after emails)
path = "../01_emails/ENVR200_2020"
listing = os.listdir(path)
#2. where to save the files (change the part after data)
output = "../02_data/20200309_data/"
num = 1

#3. to run the file - save current file > right click save_eml_attachments.py > click run python file in terminal > check contents
for fle in listing:
    if str.lower(fle[-3:])=="eml":
        msg = email.message_from_file(open(path + '/' + fle))
        attachments=msg.get_payload()
        for attachment in attachments:
            try:
                fnam=attachment.get_filename().split(".") 
                fn = output + fnam[0] + str(num) + "." + fnam[1]
                f=open(fn, 'wb').write(attachment.get_payload(decode=True))
                f.close()
            except Exception as detail:
                #print detail
                pass
            num += 1 

