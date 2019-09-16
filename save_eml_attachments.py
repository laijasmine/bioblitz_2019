import email
import os

path = './Thur._SCIE_001_Inventory_-_13'
listing = os.listdir(path)
output = "./result/"
num = 1

for fle in listing:
    if str.lower(fle[-3:])=="eml":
        msg = email.message_from_file(open('./Thur._SCIE_001_Inventory_-_13/' + fle))
        attachments=msg.get_payload()
        for attachment in attachments:
            try:
                fnam=attachment.get_filename().split(".") 
                fn = output + fnam[0] + str(num) + ".xlsx"
                f=open(fn, 'wb').write(attachment.get_payload(decode=True))
                f.close()
            except Exception as detail:
                #print detail
                pass
            num += 1
            