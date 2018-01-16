d:
mkdir androidDB
cd d:/androidDB
d:
del *.db
del *.db-shm
del *.db-wal

@echo all *.db have been deleted.

adb pull /storage/sdcard0/mtklog C:\Users\%username%\Desktop\mtklog
pause
exit 0

:: contact DB
adb pull /data/data/com.android.providers.contacts/databases/contacts2.db d:/androidDB
adb pull /data/data/com.android.providers.contacts/databases/contacts2.db-journal d:/androidDB



:: telephony db
adb pull /data/data/com.android.providers.telephony/databases/telephony.db d:/androidDB
adb pull /data/data/com.android.providers.telephony/databases/telephony.db-journal d:/androidDB

:: settings DB
adb pull /data/data/com.android.providers.settings/databases/settings.db d:/androidDB
adb pull /data/data/com.android.providers.settings/databases/settings.db-journal d:/androidDB

:: MMS db
adb pull /data/data/com.android.providers.telephony/databases/mmssms.db d:/androidDB

::adb pull /mnt/shell/emulated/0/mtklog C:\Users\sunhuihui\Desktop\mtklog

adb pull /data/data/com.android.launcher3/databases/launcher.db d:/androidDB
adb pull /data/data/com.android.launcher3/databases/launcher.db-journal d:/androidDB

:: media DB
adb pull /data/data/com.android.providers.media/databases/external.db d:/androidDB
adb pull /data/data/com.android.providers.media/databases/external.db-shm d:/androidDB
adb pull /data/data/com.android.providers.media/databases/external.db-wal d:/androidDB
adb pull /data/data/com.android.providers.media/databases/internal.db d:/androidDB

:: telephony db
adb pull /data/data/com.android.providers.telephony/databases/telephony.db d:/androidDB
adb pull /data/data/com.android.providers.telephony/databases/telephony.db-journal d:/androidDB

:: media DB
adb pull /data/data/com.android.providers.media/databases/external.db d:/androidDB
adb pull /data/data/com.android.providers.media/databases/external.db-shm d:/androidDB
adb pull /data/data/com.android.providers.media/databases/external.db-wal d:/androidDB
adb pull /data/data/com.android.providers.media/databases/internal.db d:/androidDB

:: Email DB
adb pull /data/data/com.android.email/databases/EmailProvider.db d:/androidDB
adb pull  /data/data/com.android.email/databases/EmailProvider.db-journal d:/androidDB



::browser
adb pull /data/data/com.android.browser/databases/browser2.db d:/androidDB
adb pull /data/data/com.android.browser/databases/browser2.db-shm d:/androidDB
adb pull /data/data/com.android.browser/databases/browser2.db-wal d:/androidDB




:: media DB
adb pull /data/data/com.android.providers.media/databases/external.db d:/androidDB
adb pull /data/data/com.android.providers.media/databases/external.db-shm d:/androidDB
adb pull /data/data/com.android.providers.media/databases/external.db-wal d:/androidDB
::adb pull /data/data/com.android.providers.media/databases/internal.db d:/androidDB



adb pull /data/data/com.android.browser/databases/websites.db d:/androidDB
adb pull /data/data/com.android.browser/databases/websites.db-journal d:/androidDB




:: telephony db
adb pull /data/data/com.android.providers.telephony/databases/telephony.db d:/androidDB
adb pull /data/data/com.android.providers.telephony/databases/telephony.db-journal d:/androidDB



::download DB
adb pull /data/data/com.android.providers.downloads/databases/downloads.db d:/androidDB




echo Ok
pause