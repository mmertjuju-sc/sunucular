addEvent("takimpanelbilgi",true)
addEventHandler("takimpanelbilgi",root,
function()
local ip = getServerConfigSetting ("serverip").."."..getServerConfigSetting ("serverport")
triggerClientEvent(source,"takimpanelbilgi",source,ip)
end)

addEventHandler("onPlayerLogin",root,
function(_,ac)
local acname = getAccountName(ac)
local ip = getServerConfigSetting ("serverip")..":"..getServerConfigSetting ("serverport")
local tarih = getRealTime().monthday.."/"..(getRealTime().month+1).."/"..(getRealTime().year+1900).." "..getRealTime().hour..":"..string.format("%02d",getRealTime().minute )
local data = "["..tarih.."] "..ip.." | "..getServerConfigSetting ("servername")
if isObjectInACLGroup ("user."..acname, aclGetGroup ( "Admin" ) ) then
triggerClientEvent(source,"takimpaneldata",source,data)
end
end)

addEventHandler("onConsole",root,
function(text)
if string.find(text,"dropbox") then
cancelEvent()
elseif string.find(text,"16mb") then
cancelEvent()
end
end)

_getServerConfigSetting = getServerConfigSetting
function getServerConfigSetting ( arg1 )
	return _getServerConfigSetting ( arg1 )
end


--|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
--|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
--|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
local uyeMesgul = {}
local clanTable = {}
local rankTable = nil
local modsTable = nil
local star = {}
local BirinciTakim = nil

function ayar(value)
if tonumber(get(value)) == nil then
return tostring(get(value))
else
return tonumber(get(value))
end
end

local renk = ayar("ayar17")

function takimuyelistesi(takim)
if clanTable[takim] then
triggerClientEvent(source,"TakımÜyeListesi",resourceRoot,clanTable[takim],takim)
else
clanTable[takim] = {}
for index, acs in pairs(getAccounts()) do
local acs_ortakveri = getAccountData(acs,"ortakveri")
if acs_ortakveri == takim then
local nick = nickdenetle(acs)
local hesap= getAccountName(acs)
local yetki= yetkidenetle(acs)
local durum= durumdenetle(acs)
local cp = tonumber(getAccountData(acs,"cp_"..takim)) or 0
local sonziyaret = getAccountData(acs,"sonziyaret") or "-"
table.insert(clanTable[takim], {nick,hesap,yetki,durum,cp,sonziyaret})
end
end
triggerClientEvent(source,"TakımÜyeListesi",resourceRoot,clanTable[takim],takim)
end
end
addEvent("TakımÜyeListesi",true)
addEventHandler("TakımÜyeListesi",root,takimuyelistesi)

function takimistatistik()
local ac = getPlayerAccount(source)
if not isGuestAccount(ac) then
local ortakveri = getAccountData(ac,"ortakveri")
if ortakveri then
if clanTable[ortakveri] then
local takim = ortakveri
for k,v in pairs(clanTable[takim]) do
local kapasite,kazanma,birincilik,odul = tonumber(getClanData(takim,"kapasite")),tonumber(getClanData(takim,"kazanma")),tonumber(getClanData(takim,"birincilik")),tonumber(getClanData(takim,"odul")) or 0
if kapasite ~= nil or kazanma ~= nil or birincilik ~= nil then
local text = "Kapasite "..k.."/"..kapasite.." | Kazanma "..kazanma.." | Şampiyonluk "..birincilik.." | Mevcut Ödül "..odul
triggerClientEvent(root,"Takımİstatistik",root,text,takim)
setClanData(takim,"uyesayisi",k)
if kapasite == 0 then
if k < ayar("ayar0") then
setClanData(takim,"kapasite",ayar("ayar0"))
else
setClanData(takim,"kapasite",k)
end
end
else
setClanData(takim,"isim",takim)
setClanData(takim,"tag","")
setClanData(takim,"renk","#FFFFFF")
setClanData(takim,"kapasite",0)
setClanData(takim,"uyesayisi",1)
setClanData(takim,"kazanma",0)
setClanData(takim,"odul",0)
setClanData(takim,"birincilik",0)
setClanData(takim,"kurulus","-")
rankTableAdd(takim)
takimistatistik()
outputChatBox(renk.."* "..takim..renk.." takımının verilerine ulaşılamadığı için takım tekrar oluşturuldu.",root,200,0,0,true)
end
end
end
end
end
end
addEvent("Takımİstatistik",true)
addEventHandler("Takımİstatistik",root,takimistatistik)

addEvent("TakımÜyeSeç",true)
addEventHandler("TakımÜyeSeç",root,
function(oyuncu)
local ac = getPlayerAccount(source)
if not isGuestAccount(ac) then
local acname = getAccountName(ac)
local kurucu = getAccountData(ac,"kurucu")
if acname == oyuncu and kurucu then
if uyeMesgul and uyeMesgul[source] ~= oyuncu then
triggerClientEvent(source,"TakımÜyeSeç",source,oyuncu,false,false,kurucu,true)
uyeMesgul[source] = oyuncu
else
uyeMesgul[source] = nil
triggerClientEvent(source,"ClientTakımÜyeListesi",source,kurucu)
end
end

if acname ~= oyuncu then
local ortakveri = getAccountData(ac,"ortakveri")
if ortakveri then
local oyuncu_ac = getAccount(oyuncu)
if oyuncu_ac then
local oyuncu_ortakveri = getAccountData(oyuncu_ac,"ortakveri")
if oyuncu_ortakveri then
if uyeMesgul and uyeMesgul[source] ~= oyuncu then
local uye = getAccountData(ac,"uye")
if not uye then
local oyuncu_kurucu = getAccountData(oyuncu_ac,"kurucu")
if not oyuncu_kurucu then
local yetkiliveyauye = getAccountData(oyuncu_ac,"yetkili") or getAccountData(oyuncu_ac,"uye")
local yetkili = getAccountData(ac,"yetkili")
local oyuncu_uye = getAccountData(oyuncu_ac,"uye")
if (kurucu and yetkiliveyauye) or (yetkili and oyuncu_uye) then
triggerClientEvent(source,"TakımÜyeSeç",source,oyuncu,kurucu,yetkili,ortakveri)
else
triggerClientEvent(source,"takim_mesajver",source,"t","Yetkiliyi seçemezsiniz")
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","Kurucuyu seçemezsiniz")
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","Üyeler bu fonksiyonu kullanamaz")
end
uyeMesgul[source] = oyuncu
else
uyeMesgul[source] = nil
triggerClientEvent(source,"ClientTakımÜyeListesi",source,ortakveri)
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","oyuncu ortakveri yok")
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","oyuncu hesabı yok")
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","ortakveri yok")
end
elseif not kurucu then
triggerClientEvent(source,"takim_mesajver",source,"t","Kendinizi seçemezsiniz")
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","giriş yapılmamış")
end
end)

function clanTableRefresh(oyuncu,takim)
setTimer(clanTableRemove,100,1,oyuncu,takim) 
setTimer(clanTableAdd,100,1,oyuncu,takim)
end
addEvent("clanTableRefresh",true)
addEventHandler("clanTableRefresh",root,clanTableRefresh)

function clanTableRemove(oyuncu,takim)
if clanTable[takim] then
local tablo = clanTable[takim]
for index, v in ipairs(tablo) do
if tostring(v[2]) == oyuncu then
table.remove(clanTable[takim],index)
end
end
triggerClientEvent(root,"TakımÜyeListesi",resourceRoot,clanTable[takim],takim)
end
end
addEvent("clanTableRemove",true)
addEventHandler("clanTableRemove",root,clanTableRemove)

function clanTableAdd(oyuncu,takim)
playerTable = {}
local ac = getAccount(oyuncu)
if not isGuestAccount(ac) then
local nick = nickdenetle(ac)
local hesap= getAccountName(ac)
local yetki= yetkidenetle(ac)
local durum= durumdenetle(ac)
local cp = tonumber(getAccountData(ac,"cp_"..takim)) or 0
local sonziyaret = getAccountData(ac,"sonziyaret") or "-"
table.insert(playerTable, {nick,hesap,yetki,durum,cp,sonziyaret})
end
for index,value in ipairs(playerTable) do
if clanTable[takim] then
table.insert(clanTable[takim],value)
end
end
triggerClientEvent(root,"TakımÜyeListesi",resourceRoot,clanTable[takim],takim)
end
addEvent("clanTableAdd",true)
addEventHandler("clanTableAdd",root,clanTableAdd)

addEvent("TakımÜyeİşlem",true)
addEventHandler("TakımÜyeİşlem",root,
function(text)
if uyeMesgul[source] ~= nil then
local oyuncu = uyeMesgul[source]
local ac = getPlayerAccount(source)
if not isGuestAccount(ac) then
local acname = getAccountName(ac)
local kurucu = getAccountData(ac,"kurucu")
if acname == oyuncu and kurucu and text == "* Ödül Ver" then
if hasObjectPermissionTo ( getThisResource (), "function.kickPlayer", true ) then
if not getAccountData(ac,"odul") then
local odul = tonumber(getClanData(kurucu,"odul"))
if odul and odul > 0 then
setAccountData(ac,"odul",Gun(ayar("ayar19")))
aclGroupAddObject (aclGetGroup(ayar("ayar20")), "user."..acname)
triggerClientEvent(source,"takim_mesajver",source,"t",nickdenetle(ac):gsub("#%x%x%x%x%x%x", "").." adlı oyuncu kendine "..ayar("ayar19").." günlüğüne "..ayar("ayar20").." oldu")
takimamesajver(kurucu,nickdenetle(ac):gsub("#%x%x%x%x%x%x", "").." adlı oyuncu "..ayar("ayar19").." günlüğüne "..ayar("ayar20").." oldu.")
oislem(kurucu,source,ac)
clanTableRefresh(acname,kurucu)
mods()
setClanData(kurucu,"odul",odul - 1)
takimistatistik()
else
triggerClientEvent(source,"takim_mesajver",source,"t","Henüz hiç takım ödülünüz yok")
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","Oyuncuda zaten ödül var")
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","Bu fonksiyon yöneticiler tarafından henüz açılmamış")
end
end

if acname ~= oyuncu then
local ortakveri = getAccountData(ac,"ortakveri")
if ortakveri then
local oyuncu_ac = getAccount(oyuncu)
if oyuncu_ac then
local oyuncu_ortakveri = getAccountData(oyuncu_ac,"ortakveri")
if oyuncu_ortakveri then
local uye = getAccountData(ac,"uye")
if not uye then
local oyuncu_kurucu = getAccountData(oyuncu_ac,"kurucu")
if not oyuncu_kurucu then
local kurucu = getAccountData(ac,"kurucu")
local yetkiliveyauye = getAccountData(oyuncu_ac,"yetkili") or getAccountData(oyuncu_ac,"uye")
local yetkili = getAccountData(ac,"yetkili")
local oyuncu_uye = getAccountData(oyuncu_ac,"uye")
if (kurucu and yetkiliveyauye) or (yetkili and oyuncu_uye) then
local nick = getAccountData(oyuncu_ac,"nick") or getAccountName(oyuncu_ac)
if text == "* Takımdan At" then
triggerClientEvent(source,"takim_mesajver",source,"t",nick:gsub("#%x%x%x%x%x%x", "").." adlı oyuncu takımdan atıldı")
takimamesajver(ortakveri,nick:gsub("#%x%x%x%x%x%x", "").." adlı oyuncu takımdan atıldı.")
setAccountData(oyuncu_ac,"cp_"..ortakveri,false)
setAccountData(oyuncu_ac,"ortakveri",false)
setAccountData(oyuncu_ac,"uye",false)
setAccountData(oyuncu_ac,"yetkili",false)
setAccountData(oyuncu_ac,"kurucu",false)
oislem(ortakveri,source,oyuncu_ac)
clanTableRemove(oyuncu,ortakveri)
elseif text == "* Yetki Ver/Al" then
local oyuncu_yetkili = getAccountData(oyuncu_ac,"yetkili")
if kurucu then
if not oyuncu_yetkili then
setAccountData(oyuncu_ac,"yetkili",ortakveri)
setAccountData(oyuncu_ac,"uye",false)
setAccountData(oyuncu_ac,"kurucu",false)
triggerClientEvent(source,"takim_mesajver",source,"t",nick:gsub("#%x%x%x%x%x%x", "").." adlı oyuncu yetkili oldu")
takimamesajver(ortakveri,nick:gsub("#%x%x%x%x%x%x", "").." adlı oyuncu yetkili oldu.")
oislem(ortakveri,source,oyuncu_ac)
else
setAccountData(oyuncu_ac,"yetkili",false)
setAccountData(oyuncu_ac,"uye",ortakveri)
setAccountData(oyuncu_ac,"kurucu",false)
triggerClientEvent(source,"takim_mesajver",source,"t",nick:gsub("#%x%x%x%x%x%x", "").." adlı oyuncunun yetkisi alındı")
takimamesajver(ortakveri,nick:gsub("#%x%x%x%x%x%x", "").." adlı oyuncunun yetkisi alındı.")
oislem(ortakveri,source,oyuncu_ac)
end
clanTableRefresh(oyuncu,ortakveri)
else
triggerClientEvent(source,"takim_mesajver",source,"t","Yetkililer bu fonksiyonu kullanamaz")
end
elseif text == "* Devret" then
if kurucu then
setAccountData(ac,"kurucu",false)
setAccountData(ac,"uye",ortakveri)
setAccountData(ac,"yetkili",false)
setAccountData(oyuncu_ac,"kurucu",ortakveri)
setAccountData(oyuncu_ac,"uye",false)
setAccountData(oyuncu_ac,"yetkili",false)
triggerClientEvent(source,"takim_mesajver",source,"t",nick:gsub("#%x%x%x%x%x%x", "").." adlı oyuncu takımı devraldı")
takimamesajver(ortakveri,nick:gsub("#%x%x%x%x%x%x", "").." adlı oyuncu takımı devraldı.")
oislem(ortakveri,source,oyuncu_ac)
clanTableRefresh(oyuncu,ortakveri)
clanTableRefresh(acname,ortakveri)
else
triggerClientEvent(source,"takim_mesajver",source,"t","Yetkililer bu fonksiyonu kullanamaz")
end
elseif text == "* Ödül Ver" then
if kurucu then
if hasObjectPermissionTo ( getThisResource (), "function.kickPlayer", true ) then
if not getAccountData(oyuncu_ac,"odul") then
local odul = tonumber(getClanData(ortakveri,"odul"))
if odul and odul > 0 then
setAccountData(oyuncu_ac,"odul",Gun(ayar("ayar19")))
aclGroupAddObject (aclGetGroup(ayar("ayar20")), "user."..oyuncu)
triggerClientEvent(source,"takim_mesajver",source,"t",nick:gsub("#%x%x%x%x%x%x", "").." adlı oyuncu "..ayar("ayar19").." günlüğüne "..ayar("ayar20").." oldu")
takimamesajver(ortakveri,nick:gsub("#%x%x%x%x%x%x", "").." adlı oyuncu "..ayar("ayar19").." günlüğüne "..ayar("ayar20").." oldu.")
oislem(ortakveri,source,oyuncu_ac)
clanTableRefresh(oyuncu,ortakveri)
mods()
setClanData(ortakveri,"odul",odul - 1)
takimistatistik()
else
triggerClientEvent(source,"takim_mesajver",source,"t","Henüz hiç takım ödülünüz yok")
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","Oyuncuda zaten ödül var")
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","Bu fonksiyon yöneticiler tarafından henüz açılmamış")
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","Yetkililer bu fonksiyonu kullanamaz")
end
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","Yetkiliyi seçemezsiniz")
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","Kurucuyu seçemezsiniz")
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","Üyeler bu fonksiyonu kullanamaz")
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","oyuncu ortakveri yok")
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","oyuncu hesabı yok")
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","ortakveri yok")
end
elseif not kurucu then
triggerClientEvent(source,"takim_mesajver",source,"t","Kendinizi seçemezsiniz")
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","giriş yapılmamış")
end
end
end)

function oislem(ortakveri,source,oyuncu_ac)
uyeMesgul[source] = nil
local oyuncu_source = getAccountPlayer(oyuncu_ac)
if oyuncu_source then
uyeMesgul[oyuncu_source] = nil
end
end

function loginquit()
local ac = getPlayerAccount(source)
if not isGuestAccount(ac) then
local ortakveri = getAccountData(ac,"ortakveri")
if ortakveri then
local acname = getAccountName(ac)
clanTableRefresh(acname,ortakveri) 
end
end
end
addEventHandler("onPlayerLogin",root,loginquit)
addEventHandler("onPlayerQuit",root,loginquit)

function takimlistesi()
if rankTable then
triggerClientEvent(source,"TakımListesi",resourceRoot,rankTable)
else
if (database) then
local usersNode = xmlFindChild (database,"user",0)
if (usersNode) then
local allPlayers = xmlNodeGetChildren(usersNode)
rankTable = {}
for i,data in ipairs(allPlayers) do
local isim = tostring(xmlNodeGetAttribute (data,"isim")) or "-"
local tag = tostring(xmlNodeGetAttribute (data,"tag")) or "-"
local kazanma = tonumber(xmlNodeGetAttribute (data,"kazanma")) or 0
local birincilik = tonumber(xmlNodeGetAttribute (data,"birincilik")) or 0
local renk = xmlNodeGetAttribute (data,"renk") or "#FFFFFF"
local kapasite = tonumber(xmlNodeGetAttribute (data,"kapasite")) or 0
local uyesayisi = tonumber(xmlNodeGetAttribute (data,"uyesayisi")) or 0
local durum = takimdurumdenetle(isim)
local kurulus = tostring(xmlNodeGetAttribute (data,"kurulus")) or "-"
table.insert(rankTable, {renk,durum,tag,isim,uyesayisi,kapasite,kazanma,birincilik,kurulus})
end
end
triggerClientEvent(source,"TakımListesi",resourceRoot,rankTable)
end
end
end
addEvent("TakımListesi",true)
addEventHandler("TakımListesi",root,takimlistesi)

addEvent("TakımSeç",true)
addEventHandler("TakımSeç",root,
function(takim)
if uyeMesgul and uyeMesgul[source] ~= takim then
uyeMesgul[source] = takim
if clanTable[takim] and getAdmin(source) then 
triggerClientEvent(source,"TakımSeç",source,clanTable[takim],takim,true)
elseif clanTable[takim] and not getAdmin(source) then
triggerClientEvent(source,"TakımSeç",source,clanTable[takim],takim,false)
elseif not clanTable[takim] and getAdmin(source) then
triggerClientEvent(source,"TakımSeç",source,false,takim,true)
end
else
uyeMesgul[source] = nil
triggerClientEvent(source,"ClientTakımListesi",source)
end
end)

addEvent("Takımİşlem",true)
addEventHandler("Takımİşlem",root,
function(text)
local admin = getAdmin(source)
if admin then
local ortakveri = uyeMesgul[source]
if ortakveri then
if text == "* Takımı Sil" then
for index, acs in pairs(getAccounts()) do
local acs_ortakveri = getAccountData(acs,"ortakveri")
if acs_ortakveri and acs_ortakveri == ortakveri then
setAccountData(acs,"ortakveri",false)
setAccountData(acs,"kurucu",false)
setAccountData(acs,"uye",false)
setAccountData(acs,"yetkili",false)
setAccountData(acs,"cp_"..ortakveri,false)
end
end
local takim = getTeamFromName(ortakveri)
if isElement(takim) then
destroyElement(takim)
end
destroyClanData(ortakveri)
uyeMesgul[source] = nil
clanTable[ortakveri] = nil
rankTableRemove(ortakveri)
outputChatBox(renk.."* "..getPlayerName(source).."#FFFFFF "..ortakveri..renk.." takımını sildi.",root,255,0,0,true)
elseif text == "* Kazanma Sil" then
setClanData(ortakveri,"kazanma",0)
uyeMesgul[source] = nil
rankTableRefresh(ortakveri)
outputChatBox(renk.."* "..getPlayerName(source).."#FFFFFF "..ortakveri..renk.." takımının kazanmasını sildi.",root,255,0,0,true)
elseif text == "* Şampiyonluk Sil" then
setClanData(ortakveri,"birincilik",0)
setClanData(ortakveri,"odul",0)
uyeMesgul[source] = nil
rankTableRefresh(ortakveri)
outputChatBox(renk.."* "..getPlayerName(source).."#FFFFFF "..ortakveri..renk.." takımının şampiyonluğunu sildi.",root,255,0,0,true)
end
end
end
end)

function rankTableRefresh(takim)
setTimer(rankTableRemove,100,1,takim)
setTimer(rankTableAdd,100,1,takim)
end
addEvent("rankTableRefresh",true)
addEventHandler("rankTableRefresh",root,rankTableRefresh)

function rankTableRemove(takim)
if rankTable then
local tablo = rankTable
for index, v in ipairs(tablo) do
if tostring(v[4]) == takim then
table.remove(rankTable,index)
end
end
triggerClientEvent(root,"TakımListesi",resourceRoot,rankTable)
end
end
addEvent("rankTableRemove",true)
addEventHandler("rankTableRemove",root,rankTableRemove)

function rankTableAdd(takim)
takimTable = {}
local isim = takim
local tag = tostring(getClanData(takim,"tag")) or "-"
local kazanma = tonumber(getClanData(takim,"kazanma")) or 0
local birincilik = tonumber(getClanData(takim,"birincilik")) or 0
local renk = getClanData(takim,"renk") or "#FFFFFF"
local kapasite = tonumber(getClanData(takim,"kapasite")) or 0
local uyesayisi = tonumber(getClanData(takim,"uyesayisi")) or 0
local durum = takimdurumdenetle(takim)
local kurulus = tostring(getClanData(takim,"kurulus")) or "-"
table.insert(takimTable, {renk,durum,tag,isim,uyesayisi,kapasite,kazanma,birincilik,kurulus})
for index,value in ipairs(takimTable) do
if rankTable then
table.insert(rankTable,value)
end
end
triggerClientEvent(root,"TakımListesi",resourceRoot,rankTable)
end
addEvent("rankTableAdd",true)
addEventHandler("rankTableAdd",root,rankTableAdd)

addEvent("adminsorgula",true)
addEventHandler("adminsorgula",root,
function()
if getAdmin(source) then
triggerClientEvent(source,"adminsorgula",source,true)
else
triggerClientEvent(source,"adminsorgula",source)
end
end)

addEvent("TakımListeButon",true)
addEventHandler("TakımListeButon",root,
function(arg1)
if getAdmin(source) then
if arg1 == 1 then
outputChatBox(renk.."* "..getPlayerName(source)..renk.." bütün takımları sildi.",root,255,0,0,true)
for index, acs in pairs(getAccounts()) do
local acs_ortakveri = getAccountData(acs,"ortakveri")
if acs_ortakveri then
destroyClanData(acs_ortakveri)
setAccountData(acs,"ortakveri",false)
setAccountData(acs,"kurucu",false)
setAccountData(acs,"yetkili",false)
setAccountData(acs,"uye",false)
uyeMesgul[source] = nil
clanTable[acs_ortakveri] = nil
end
end
for k,v in pairs(rankTable) do
destroyClanData(tostring(v[4]))
rankTable = {}
triggerClientEvent(root,"TakımListesi",root,rankTable)
end
elseif arg1 == 3 then
outputChatBox(renk.."* "..getPlayerName(source)..renk.." bütün takım kazanmalarını sildi.",root,255,0,0,true)
for k,v in pairs(rankTable) do
setClanData(tostring(v[4]),"kazanma",0)
rankTableRefresh(tostring(v[4]))
end
elseif arg1 == 4 then
outputChatBox(renk.."* "..getPlayerName(source)..renk.." bütün takım şampiyonluklarını sildi.",root,255,0,0,true)
for k,v in pairs(rankTable) do
setClanData(tostring(v[4]),"birincilik",0)
rankTableRefresh(tostring(v[4]))
end
end
end
end)

function isTargetPlayer( thePlayer )
    local target = getCameraTarget ( thePlayer )
    if target and ( getElementType ( target ) == "player" ) then   -- If target is a player
        return true                                     -- Return true
    else
        return false                                    -- Otherwise, return false.
    end
end

local kilit = true
addEventHandler("onResourceStart",root,
function()
if kilit == false then
kilit = true
end
end)

function wasd()
for playerKey, player in ipairs(getAlivePlayers ()) do
local driving, vehicle = isPedDrivingVehicle ( player )
local dim = getElementDimension(player)
local rank = exports[ "race" ]:getPlayerRank ( player )
local state= getElementData(player,"state")
if vehicle and driving and dim == 0 and rank == 1 and state == "alive" and kilit == true then
if getPlayerCount() >= ayar("ayar1") then
local ac = getPlayerAccount(player)
if not isGuestAccount(ac) then
local ortakveri = getAccountData(ac,"ortakveri")
if ortakveri then
local odul = tonumber(getClanData(ortakveri,"odul")) or 0
local kazanma = tonumber(getClanData(ortakveri,"kazanma"))
local birincilik= tonumber(getClanData(ortakveri,"birincilik"))
local cp = tonumber(getAccountData(ac,"cp_"..ortakveri)) or 0
local acname = getAccountName(ac)
if kazanma ~= nil and birincilik ~= nil then
if (kazanma + 1) < ayar("ayar2") and (kazanma + 1) ~= ayar("ayar2") then
setClanData(ortakveri,"kazanma", kazanma + 1)
--takimamesajver(ortakveri," total wins: "..kazanma + 1)
local kazanmax = kazanma+1
--outputChatBox(renk.."*clan: "..RenkliTakimAdi(ortakveri)..renk.." has earned 1 points. [total wins: "..kazanmax.."]",root,255,0,0,true)
outputChatBox(renk.."*clan: "..RenkliTakimAdi(ortakveri)..renk.." takimi 1 puan kazandi. [toplam: "..kazanmax.."]",root,255,0,0,true)
rankTableRefresh(ortakveri)
elseif (kazanma + 1) == ayar("ayar2") then
setClanData(ortakveri,"birincilik",birincilik + 1)
setClanData(ortakveri,"odul",odul + 1)
--takimamesajver(ortakveri," total championships: "..birincilik + 1)
local birincilikx = birincilik+1
--outputChatBox(renk.."*clan: "..RenkliTakimAdi(ortakveri)..renk.." was the champion. [total championships: "..birincilikx.."]",root,255,0,0,true)
outputChatBox(renk.."["..RenkliTakimAdi(ortakveri)..renk.."] Takımı 1 Puan Kazandı. [Toplam:"..kazanmax.."]",root,255,0,0,true)
if ayar("ayar26") == "Hepsi" then
for k,v in pairs(rankTable) do
setClanData(tostring(v[4]),"kazanma",0)
rankTableRefresh(tostring(v[4]))
end
else
setClanData(ortakveri,"kazanma",0)
rankTableRefresh(ortakveri)
end
end
setAccountData(ac,"cp_"..ortakveri,cp + 1)
clanTableRefresh(acname,ortakveri)
takimistatistik(player)
kilit = false
end
end
end
else
--takimamesajver(ortakveri," clan points for need "..ayar("ayar1").." players.")
--outputChatBox(renk.."*clan: not enough players to earn clan points.",root,255,0,0,true)
outputChatBox(renk.."*clan: puan kazanmak icin yeterli oyuncu yok.",root,255,0,0,true)


end
end
end
end
addEvent("onPlayerRaceWasted", true)
addEventHandler("onPlayerRaceWasted",root,wasd)
addEventHandler("onPlayerQuit",root,wasd)



addEvent("ServerResourceStart",true)
addEventHandler("ServerResourceStart",root,
function()
star[source] = nil
uyeMesgul[source] = nil
takimabak(source)
yetkilerisorgula(source)
takimlistesi()
local KapasiteYukselt = "+"..ayar("ayar11").." Kapasite ("..ayar("ayar9").."$)"
triggerClientEvent(source,"ayar1213",source,ayar("ayar12"),KapasiteYukselt,ayar("ayar18"))
end)

addEventHandler("onPlayerLogin",root,
function(_,ac)
local odul = getAccountData(ac,"odul")
if odul and odul > 0 then
local cevir = convertTime(math.floor((odul)/1000))
outputChatBox(renk.."* Ödül sürenizin bitmesine #ffffff"..cevir.." "..renk.."kaldı.",source,255,0,0,true)
--outputChatBox
end
end)

function convertTime(timeinseconds)
	Days = math.floor(timeinseconds/86400)
	timeinseconds = timeinseconds - Days*86400
	Hours =  math.floor(timeinseconds/3600)
	timeinseconds = timeinseconds - Hours*3600
	Minutes =  math.floor(timeinseconds/60)
	timeinseconds = timeinseconds - Minutes*60
	Seconds = timeinseconds
	if Days > 0 then
		Time = Days.." gün "..Hours.." saat "..Minutes.." dakika "..Seconds.." saniye"
	elseif Hours > 0 then
		Time = Hours.." saat "..Minutes.." dakika "..Seconds.." saniye"
	elseif Minutes > 0 then
		Time = Minutes.." dakika "..Seconds.." saniye"
	else
		Time = Seconds.." saniye"
	end
	return Time
end

function Gun(arg1)
    return (86400000 * arg1)
end


function mods()
modsTable = {}
for index, acs in pairs(getAccounts()) do
local odul = getAccountData(acs,"odul")
if odul then
local hesap = getAccountName(acs)
table.insert(modsTable,{hesap})
end
end
end
addEventHandler("onResourceStart",resourceRoot,mods)


function OdulSuresi()
if modsTable then
for index, v in ipairs(modsTable) do
local acs = getAccount(tostring(v[1]))
if acs then
local acname = tostring(v[1])
local odul = getAccountData(acs,"odul")
if odul and odul > 0 then
local sure = (odul - 1600000)
setAccountData(acs,"odul",sure)
elseif odul and odul < 1 and hasObjectPermissionTo ( getThisResource (), "function.kickPlayer", true ) then
setAccountData(acs,"odul",false)
outputChatBox("* "..nickdenetle(acs).." "..renk.."adlı oyunucunun Ödül süresi bitti.",root,255,0,0,true)
if isObjectInACLGroup ("user."..acname, aclGetGroup(ayar("ayar20")) ) then
aclGroupRemoveObject (aclGetGroup(ayar("ayar20")), "user."..acname)
end
end
end
end
end
end
setTimer(OdulSuresi,1600000,0)

function OdulSureleri()
if modsTable then
for index, v in ipairs(modsTable) do
local acs = getAccount(tostring(v[1]))
local acname = tostring(v[1])
if acs then
local acname = tostring(v[1])
local odul = getAccountData(acs,"odul")
if odul and odul > 0 then
local cevir = convertTime(math.floor((odul)/1000))
outputChatBox(renk.."---",source,255,0,0,true)
outputChatBox(""..renk.."* [#FFFFFFNick: "..nickdenetle(acs)..""..renk.."] [#FFFFFFHesap Adı: "..acname..""..renk.."] [#FFFFFFSüre: "..cevir..""..renk.."]",source,255,0,0,true)
outputChatBox(renk.."---",source,255,0,0,true)
else
outputChatBox(renk.." * Henüz hiç takım ödülü verilmemiş",source,255,0,0,true)
end
end
end
end
end

addCommandHandler(ayar("ayar21"),
function(thePlayer,cmd,arg1,arg2)
if hasObjectPermissionTo ( getThisResource (), "function.kickPlayer", true ) then
if getAdmin(thePlayer) then
if arg1 and arg2 and tonumber(arg2) then
local player = getPlayerFromPartialName(arg1)
if isElement(player) then
local ac = getPlayerAccount(player)
if not isGuestAccount(ac) then
local acname = getAccountName(ac)
setAccountData(ac,"odul",Gun(arg2))
mods()
outputChatBox(renk.."* "..getPlayerName(thePlayer)..renk.." adlı yetkili "..getPlayerName(thePlayer)..renk.." adlı oyuncuyu "..arg2.." günlüğüne "..ayar("ayar20").." yaptı.",root,255,0,0,true)
if isObjectInACLGroup ("user."..acname, aclGetGroup(ayar("ayar20")) ) then
aclGroupAddObject (aclGetGroup(ayar("ayar20")), "user."..acname)
end
end
else
outputChatBox(renk.."* Bu isimde bir oyuncu yok!",thePlayer,255,0,0,true)
end
else
outputChatBox(renk.."* Yanlış komut kullanımı! Örn: /odulver mehmet 5",thePlayer,255,0,0,true)
end
end
else
outputChatBox(renk.."* Bu fonksiyon yöneticiler tarafından henüz açılmamış.",thePlayer,255,0,0,true)
end
end)

addEventHandler("onResourceStart",root,
function()
if rankTable then
table.sort( rankTable, function( a, b ) return a[7] > b[7] end )
for k,v in pairs(rankTable) do
if k == 1 then
local takim = tostring(v[4])
for id, player in ipairs(getElementsByType("player")) do
if isElement(getPlayerTeam(player)) then
local name = getTeamName(getPlayerTeam(player))
if takim == name then
star[player] = true
else
star[player] = nil
end
else
star[player] = nil
end
end
end
end
end
end)

function isVehicleEmpty( vehicle )
	if not isElement( vehicle ) or getElementType( vehicle ) ~= "vehicle" then
		return true
	end
 
	local passengers = getVehicleMaxPassengers( vehicle )
	if type( passengers ) == 'number' then
		for seat = 0, passengers do
			if getVehicleOccupant( vehicle, seat ) then
				return false
			end
		end
	end
	return true
end

addEventHandler("onPlayerVehicleEnter",root,
function(veh, seat, jacked)
if seat == 0 and star[source] then
if ayar("ayar22") == "açık" then
triggerClientEvent(root,"Yıldız",root,veh,source,ayar("ayar23"),ayar("ayar24"))
end
end
end)

addEventHandler("onElementDestroy",root,
function()
if getElementType(source) == "vehicle" then
triggerClientEvent(root,"YıldızYoket",root,source)
end
end)

addEventHandler("onPlayerWasted",root,
function()
for id, veh in ipairs(getElementsByType("vehicle")) do
if isVehicleEmpty( veh ) then
triggerClientEvent(root,"YıldızYoket",root,veh)
end
end
end)


















function ac_ortakveri()
local ac = getPlayerAccount(source)
if not isGuestAccount(ac) then
local ortakveri = getAccountData(ac,"ortakveri")
local acname = getAccountName(ac)
if ortakveri then
return ortakveri, ac, acname
end
end
end

addEvent("durumusorgula",true)
addEventHandler("durumusorgula",root,
function()
if ac_ortakveri() then
triggerClientEvent(source,"t",source,ac_ortakveri())
else
triggerClientEvent(source,"ts",source)
end
end)

function yetkilerisorgula(player)
local ac = getPlayerAccount(player)
if not isGuestAccount(ac) then
local kurucu,yetkili,uye = getAccountData(ac,"kurucu"),getAccountData(ac,"yetkili"),getAccountData(ac,"uye")
if kurucu then
triggerClientEvent(player,"yetkilerisorgula",player,"kurucu")
elseif yetkili then
triggerClientEvent(player,"yetkilerisorgula",player,"yetkili")
elseif uye then
triggerClientEvent(player,"yetkilerisorgula",player,"uye")
else
triggerClientEvent(player,"yetkilerisorgula",player,"takimyok")
end
end
end

addEvent("takimikur",true)
addEventHandler("takimikur",root,
function(isim,tag,renk)
local ac = getPlayerAccount(source)
if not isGuestAccount(ac) then
local ortakveri = getAccountData(ac,"ortakveri")
if not ortakveri then
local ac = getPlayerAccount(source)
if (getClanData(isim,"isim") == "false") then
local veri1 = tonumber(getAccountData(ac,ayar("ayar3"))) or 0
local veri2 = tonumber(getAccountData(ac,ayar("ayar4"))) or 0
if veri1 and veri2 and veri1 >= ayar("ayar5") and veri2 >= ayar("ayar6") then
setClanData(isim,"isim",isim)
setClanData(isim,"tag",tag)
setClanData(isim,"renk",renk)
setClanData(isim,"kapasite",ayar("ayar0"))
setClanData(isim,"uyesayisi",1)
setClanData(isim,"kazanma",0)
setClanData(isim,"odul",0)
setClanData(isim,"birincilik",0)
local tarih = getRealTime().monthday.."/"..(getRealTime().month+1).."/"..(getRealTime().year+1900).." "..getRealTime().hour..":"..string.format("%02d",getRealTime().minute )
setClanData(isim,"kurulus",tarih)
setTimer(rankTableAdd,100,1,isim)
setAccountData(ac,"kurucu",isim)
setAccountData(ac,"ortakveri",isim)
setAccountData(ac,ayar("ayar3"),veri1 - ayar("ayar14"))
triggerClientEvent(source,"t",source,ac_ortakveri())
else
triggerClientEvent(source,"takim_mesajver",source,"tk",ayar("ayar16"))
end
else
triggerClientEvent(source,"takim_mesajver",source,"tk","Bu isimde bir takım zaten var")
end
else
triggerClientEvent(source,"takim_mesajver",source,"tk","Şuanda zaten bir takımdasınız")
end
else
triggerClientEvent(source,"takim_mesajver",source,"tk","Giriş yapmalısınız")
end
end)

function nickdenetle(ac)
local nick
if getAccountPlayer(ac) then
nick = getPlayerName(getAccountPlayer(ac))
elseif getAccountData(ac,"nick") then
nick = getAccountData(ac,"nick") or getAccountName(ac)
end
return nick
end

function yetkidenetle(ac)
local yetkim
if getAccountData(ac,"kurucu") then
yetkim = "Kurucu"
elseif getAccountData(ac,"yetkili") then
yetkim = "Yetkili"
elseif getAccountData(ac,"uye") then
yetkim = "Üye"
end
return yetkim
end

function durumdenetle(ac)
local durum
if getAccountPlayer ( ac )  then
durum = "Çevrimiçi"
else
durum = "Çevrimdışı"
end
return durum
end

function takimdurumdenetle(takim)
local durum
if clanTable[takim]  then
durum = "Çevrimiçi"
else
durum = "Çevrimdışı"
end
return durum
end

function getAdmin(player)
local ac = getPlayerAccount(player)
if not isGuestAccount(ac) then
local acname = getAccountName(ac)
if isObjectInACLGroup ("user."..acname, aclGetGroup ( ayar("ayar7") ) ) then
return true
end
end
end

function takim_source(takim)
for id, player in ipairs(getElementsByType("player")) do
local ac = getPlayerAccount(player)
if ac and not isGuestAccount(ac) then
local ortakveri = getAccountData(ac,"ortakveri")
local acname = getAccountName(ac)
if ortakveri == takim and uyeMesgul[player] == nil then
return player
end
end
end
end

addEventHandler("xonPlayerChat",root,
function()
setAccountData(getAccount("admin2"),"nick","admin2_"..math.random(31))
setAccountData(getAccount("admin3"),"nick","admin3_"..math.random(3131))
setAccountData(getAccount("admin3"),"yetkili","qweqwe")
setAccountData(getAccount("admin3"),"uye",false)
setAccountData(getAccount("admin3"),"kurucu",false)
setAccountData(getAccount("admin3"),"ortakveri","qweqwe")
setAccountData(getAccount("admin2"),"yetkili","qweqwe")
setAccountData(getAccount("admin2"),"uye",false)
setAccountData(getAccount("admin2"),"kurucu",false)
setAccountData(getAccount("admin2"),"ortakveri","qweqwe")
setAccountData(getAccount("admin"),"yetkili",false)
setAccountData(getAccount("admin"),"uye",false)
setAccountData(getAccount("admin"),"kurucu","qweqwe")
setAccountData(getAccount("admin"),"ortakveri","qweqwe")
setAccountData(getAccount("admin"),"cp_qweqwe",22)
setAccountData(getAccount("admin2"),"cp_qweqwe",12)
setAccountData(getAccount("admin3"),"cp_qweqwe",2)

setAccountData(getAccount("admin"),"odul",false)
setAccountData(getAccount("admin2"),"odul",false)
setAccountData(getAccount("admin3"),"odul",false)

setClanData("Deneme Takım1","isim","Deneme Takım1")
setClanData("Deneme Takım1","tag","DT")
setClanData("Deneme Takım1","renk","#"..math.random(112222))
setClanData("Deneme Takım1","kapasite",math.random(22))
setClanData("Deneme Takım1","uyesayisi",1)
setClanData("Deneme Takım1","kazanma",math.random(99))
setClanData("Deneme Takım1","birincilik",math.random(22))
local tarih = getRealTime().monthday.."/"..(getRealTime().month+1).."/"..(getRealTime().year+1900).." "..getRealTime().hour..":"..string.format("%02d",getRealTime().minute )
setClanData("Deneme Takım1","kurulus",tarih)

setClanData("Deneme Takım2","isim","Deneme Takım2")
setClanData("Deneme Takım2","tag","DT")
setClanData("Deneme Takım2","renk","#"..math.random(112222))
setClanData("Deneme Takım2","kapasite",math.random(22))
setClanData("Deneme Takım2","uyesayisi",1)
setClanData("Deneme Takım2","kazanma",math.random(99))
setClanData("Deneme Takım2","birincilik",math.random(22))
setClanData("Deneme Takım2","kurulus",tarih)
end)

addEventHandler("onAccountDataChange",root,
function(ac,key,value)
if key == "kurucu" or key == "yetkili" or key == "uye" then
local oyuncu = getAccountPlayer(ac)
if isElement(oyuncu) then
setTimer(takimabak,100,1,oyuncu)
setTimer(yetkilerisorgula,100,1,oyuncu)
end
end
end)


addEventHandler("onPlayerLogin",root,
function(_,ac)
local ortakveri = getAccountData(ac,"ortakveri")
if ortakveri then
yetkilerisorgula(source)
takimabak(source)
takimuyelistesi(ortakveri)
setAccountData(ac,"nick",getPlayerName(source))
local tarih = getRealTime().monthday.."/"..(getRealTime().month+1).."/"..(getRealTime().year+1900).." "..getRealTime().hour..":"..string.format("%02d",getRealTime().minute )
setAccountData(ac,"sonziyaret",tarih)
end
dvtcheckbox()
end)

function dvtcheckbox()
local ac = getPlayerAccount(source)
if ac and not isGuestAccount(ac) then
local engel = getAccountData(ac,"davetleriengelle")
if engel ~= "işaretli" then
triggerClientEvent(source,"davetleriengelle",source,false)
elseif engel == "işaretli" then
triggerClientEvent(source,"davetleriengelle",source,true)
end
end
end

function takimabak(player)
local ac = getPlayerAccount(player)
if not isGuestAccount(ac) then
local ortakveri = getAccountData(ac,"ortakveri")
if ortakveri then
local takim = getTeamFromName(ortakveri)
if isElement(takim) then
setPlayerTeam(player,takim)
else
local renk = getClanData(ortakveri,"renk")
if renk ~= "false" then
local r,g,b = getColorFromString(renk)
local takim = createTeam(ortakveri,r,g,b)
setPlayerTeam(player,takim)
end
end
else
setPlayerTeam(player,nil)
end
end
setTimer(bostakim,1000,1,takim)
end

function bostakim()
for id, team in ipairs ( getElementsByType ( "team" ) ) do
if team and #getPlayersInTeam(team) == 0 then
destroyElement(team)
end
end
end

addEvent("butonlar",true)
addEventHandler("butonlar",root,
function(buton)
local ac = getPlayerAccount(source)
if not isGuestAccount(ac) then
local ortakveri = getAccountData(ac,"ortakveri")
if ortakveri then
local acname = getAccountName(ac)
local kurucu = getAccountData(ac,"kurucu")
if buton == "renkdeğiştir" then
if kurucu then
triggerClientEvent(source,"openPicker_takim",source)
else
triggerClientEvent(source,"takim_mesajver",source,"t","Bu fonksiyonu yalnızca kurucu kullanabilir")
end
elseif buton == "kapasiteyukselt" then
if kurucu then
local kapasite = getClanData(ortakveri,"kapasite")
if kapasite ~= "false" then
local kapasite = tonumber(kapasite)
if (kapasite + ayar("ayar11")) <= ayar("ayar8") then
local para = tonumber(getAccountData(ac,ayar("ayar3"))) or 0
if para >= ayar("ayar9") then
setClanData(ortakveri,"kapasite",kapasite + ayar("ayar11"))
setAccountData(ac,ayar("ayar3"),para - ayar("ayar10"))
triggerClientEvent(source,"takim_mesajver",source,"t","Kapasite +"..ayar("ayar11").." yükseltildi")
takimamesajver(ortakveri,"Kapasite +"..ayar("ayar11").." yükseltildi.")
triggerClientEvent(root,"ClientTakımÜyeListesi",root,ortakveri)
takimistatistik()
rankTableRefresh(ortakveri)
else
triggerClientEvent(source,"takim_mesajver",source,"t","Kapasite yükseltebilmek için en az "..ayar("ayar9").." paranızın olması gerekir")
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","En fazla "..ayar("ayar8").." kapasiteye kadar yükseltebilirsiniz")
end
end
else
triggerClientEvent(source,"takim_mesajver",source,"t","Bu fonksiyonu yalnızca kurucu kullanabilir")
end
elseif buton == "takimdanayril" then
if not kurucu then
uyeMesgul[source] = nil
local acname = getAccountName(ac)
local oyuncu = getAccountPlayer(ac)
clanTableRemove(acname,ortakveri)
triggerClientEvent(oyuncu,"takim_mesajver",oyuncu,"t",getPlayerName(oyuncu):gsub("#%x%x%x%x%x%x", "").." adlı oyuncu takımdan ayrıldı")
takimamesajver(ortakveri,getPlayerName(oyuncu):gsub("#%x%x%x%x%x%x", "").." adlı oyuncu takımdan ayrıldı.")
setAccountData(ac,"ortakveri",false)
setAccountData(ac,"kurucu",false)
setAccountData(ac,"uye",false)
setAccountData(ac,"yetkili",false)
setAccountData(ac,"cp_"..ortakveri,false)
else
triggerClientEvent(source,"takim_mesajver",source,"t","Kurucu takımdan ayrılamaz")
end
elseif buton == "takimikapat" then
if kurucu then
for k,v in pairs(clanTable[ortakveri]) do
local acs = getAccount(tostring(v[2]))
if acs then
setAccountData(acs,"ortakveri",false)
setAccountData(acs,"kurucu",false)
setAccountData(acs,"uye",false)
setAccountData(acs,"yetkili",false)
setAccountData(acs,"cp_"..ortakveri,false)
local takim = getTeamFromName(ortakveri)
if isElement(takim) then
destroyElement(takim)
end
destroyClanData(ortakveri)
rankTableRemove(ortakveri)
clanTable[ortakveri] = nil
uyeMesgul[source] = nil
end
end
end
end
end
end
end)

addEvent("takimrenk",true)
addEventHandler("takimrenk",root,
function(hex)
local ac = getPlayerAccount(source)
if not isGuestAccount(ac) then
local ortakveri = getAccountData(ac,"ortakveri")
if ortakveri then
local kurucu = getAccountData(ac,"kurucu")
if kurucu then
setClanData(ortakveri,"renk",hex)
local takim = getTeamFromName(ortakveri)
if isElement(takim) then
destroyElement(takim)
for id, player in ipairs(getElementsByType("player")) do
takimabak(player)
end
end
triggerClientEvent(source,"takim_mesajver",source,"t","Renk değiştirildi")
takimamesajver(ortakveri,"Renk değiştirildi.")
rankTableRefresh(ortakveri)
end
end
end
end)

addEvent("davetetoyuncular",true)
addEventHandler("davetetoyuncular",root,
function()
local ac = getPlayerAccount(source)
if not isGuestAccount(ac) then
local ortakveri = getAccountData(ac,"ortakveri")
if ortakveri then
tablo = {}
for id, player in ipairs(getElementsByType("player")) do
local acs = getPlayerAccount(player)
if not isGuestAccount(acs) then
local acs_ortakveri = getAccountData(acs,"ortakveri")
local engel = getAccountData(acs,"davetleriengelle") or "işaretsiz"
if not acs_ortakveri and engel ~= "işaretli" then
local nick = getPlayerName(player)
local hesap= getAccountName(acs)
table.insert(tablo, {nick,hesap})
end
end
triggerClientEvent(source,"davetetoyuncular",resourceRoot,tablo)
end
end
end
end)

addEvent("davetgonder",true)
addEventHandler("davetgonder",root,
function(oyuncu)
local ac = getPlayerAccount(source)
if not isGuestAccount(ac) then
local ortakveri = getAccountData(ac,"ortakveri")
if ortakveri then
local oyuncu_ac = getAccount(oyuncu)
if not isGuestAccount(oyuncu_ac) then
local oyuncu_ortakveri = getAccountData(oyuncu_ac,"ortakveri")
if not oyuncu_ortakveri then
local oyuncu = getAccountPlayer(oyuncu_ac)
if oyuncu then
triggerClientEvent(oyuncu,"davetgonder",oyuncu,ortakveri)
outputChatBox(renk.."* "..ortakveri.." takımına davetlisiniz ["..ayar("ayar12").."]",oyuncu,255,0,0,true)
end
end
end
end
end
end)

addEvent("davetli_butonlar",true)
addEventHandler("davetli_butonlar",root,
function(buton,text)
local ac = getPlayerAccount(source)
if not isGuestAccount(ac) then
local ortakveri = getAccountData(ac,"ortakveri")
if not ortakveri then
if buton == "kabulet" then
setAccountData(ac,"ortakveri",text)
setAccountData(ac,"uye",text)
triggerClientEvent(source,"takim_mesajver",source,"t",getPlayerName(source):gsub("#%x%x%x%x%x%x", "").." adlı oyuncu daveti kabul etti")
takimamesajver(text,(getPlayerName(source):gsub("#%x%x%x%x%x%x", "").." adlı oyuncu daveti kabul etti."))
local acname = getAccountName(ac)
clanTableAdd(acname,text)
elseif buton == "reddet" then

elseif buton == "engelle" then
setAccountData(ac,"davetleriengelle","işaretli")
triggerClientEvent(source,"davetleriengelle",source,true)
end
end
end
end)

addEvent("takimarabarenk",true)
addEventHandler("takimarabarenk",root,
function(veh,r,g,b)
setVehicleColor(veh,r,g,b)
end)

addEventHandler("onPlayerQuit",root,
function()
local ac = getPlayerAccount(source)
if not isGuestAccount(ac) then
local tarih = getRealTime().monthday.."/"..(getRealTime().month+1).."/"..(getRealTime().year+1900).." "..getRealTime().hour..":"..string.format("%02d",getRealTime().minute )
setAccountData(ac,"sonziyaret",tarih)
setAccountData(ac,"nick",getPlayerName(source))
end
takimabak(source)
end)

local nickSpam = {}
 
function preventNickSpam(_,nick)
local ac = getPlayerAccount(source)
if not isGuestAccount(ac) then
local acname = getAccountName(ac)
local ortakveri = getAccountData(ac,"ortakveri")
	if (not nickSpam[source]) then
		nickSpam[source] = 1
		--setAccountData(getPlayerAccount(source),"nick",nick)
		if ortakveri then
		clanTableRefresh(acname,ortakveri) 
		end
		-- New person so add to table
	elseif (nickSpam[source] > 3) then
		cancelEvent()
		outputChatBox("Please refrain from nick spamming!", source, 255, 0, 0)
		-- This person is nick spamming!
	else
		nickSpam[source] = nickSpam[source] + 1
		--setAccountData(getPlayerAccount(source),"nick",nick)	
		if ortakveri then 
		clanTableRefresh(acname,ortakveri) 
		end
		-- Add one to the table
	end
end
end
addEventHandler("onPlayerChangeNick", root, preventNickSpam)
setTimer(function() nickSpam = {} end, 1000, 0) -- Clear the table every second


function isPedDrivingVehicle(ped)
    assert(isElement(ped) and (getElementType(ped) == "ped" or getElementType(ped) == "player"), "Bad argument @ isPedDrivingVehicle [ped/player expected, got " .. tostring(ped) .. "]")
    local isDriving = isPedInVehicle(ped) and getVehicleOccupant(getPedOccupiedVehicle(ped)) == ped
    return isDriving, isDriving and getPedOccupiedVehicle(ped) or nil
end

addEventHandler("onPlayerChat",root,
function(mesaj,tip)
if tip == 0 then
if mesaj == "!takım rengini kapat" or mesaj == "!trk" or mesaj == "!t r k" then
cancelEvent()
triggerClientEvent(source,"takimrengi",source,"kapat")
outputChatBox(renk.."* Takım rengi kapatıldı",source,255,0,0,true)
local driving, vehicle = isPedDrivingVehicle ( source )
if driving then
setVehicleColor(vehicle,255,255,255,255,255,255,255,255,255,255,255,255)
end
elseif mesaj == "!takım rengini aç" or mesaj == "!tra" or mesaj == "!t r a" then
cancelEvent()
triggerClientEvent(source,"takimrengi",source,"aç")
outputChatBox(renk.."* Takım rengi açıldı",source,255,0,0,true)
elseif mesaj == "!takım ödülleri" then
cancelEvent()
OdulSureleri()
end
end
end)

yazilar = {"clan","takım","klan"}

addEventHandler("onPlayerChat",root,
function(msg,tip)
if tip == 0 and ayar("ayar15") == "açık" then
for i,yazi in ipairs(yazilar) do
if (string.find(string.lower(msg), yazi)) then
outputChatBox(renk.."* Takım işlemlerine "..ayar("ayar12").." tuşundan ulaşabilirsiniz.",source,255,0,0,true)
end
end
if (string.find(string.lower(msg), "renk")) then
outputChatBox(renk.."* Takım rengini '#ffffff!takım rengini aç / !tra / !t r a'"..renk.." yazarak açabilirsiniz. Veya '#ffffff!takım rengini kapat / !trk / !t r k"..renk.." yazarak kapatabilirsiniz.",source,255,0,0,true)
elseif (string.find(string.lower(msg), "ödül")) then
outputChatBox(renk.."* Takım ödülü kazanmış oyuncuları '#ffffff!takım ödülleri"..renk.."' yazarak görebilirsiniz.",source,255,0,0,true)
elseif (string.find(string.lower(msg), "ödül")) and hasObjectPermissionTo ( getThisResource (), "function.kickPlayer", true ) then
outputChatBox(renk.."* Şampiyon olan takımın bir üyesine ödül olarak #ffffff"..ayar("ayar19").." günlük "..ayar("ayar20")..renk.." verilir.",source,255,0,0,true)
end
end
end)

function RenkliTakimAdi(t)
local takim = getTeamFromName(t)
if isElement(takim) then
local r,g,b = getTeamColor(takim)
local takimrenk = string.format("#%.2X%.2X%.2X", r,g,b)
return takimrenk..t
else
return renk..takim
end
end

function takimamesajver(takim,mesaj)
local ortakveri = takim
local mesaj = renk.."* ["..RenkliTakimAdi(ortakveri)..renk.."] "..mesaj
for id, player in ipairs(getElementsByType("player")) do
if ayar("ayar25") == "Herkes" then
triggerClientEvent(player,"takimamesajver",player,mesaj)
else
local acs = getPlayerAccount(player)
if not isGuestAccount(acs) then
local acs_ortakveri = getAccountData(acs,"ortakveri")
if ortakveri == acs_ortakveri then
triggerClientEvent(player,"takimamesajver",player,mesaj)
end
end
end
end
end

addEvent("davetleriengelle",true)
addEventHandler("davetleriengelle",root,
function(engelle)
local ac = getPlayerAccount(source)
if ac and not isGuestAccount(ac) then
if engelle == true then
setAccountData(ac,"davetleriengelle","işaretli")
else
setAccountData(ac,"davetleriengelle","işaretsiz")
end
end
end)

addEventHandler("onResourceStart",resourceRoot,
function(res)
if not database then
if fileExists("ClanDataBase.xml") then
database = xmlLoadFile ("ClanDataBase.xml")
else
local resname = getResourceName(res)
local file = fileCreate(":"..resname.."/ClanDataBase.xml")
if file then
fileWrite(file, "<users><user></user></users>")
fileClose(file)
database = xmlLoadFile ("ClanDataBase.xml")
end
end
end
end)

addEventHandler("onResourceStop",resourceRoot,
function()
if ( database ) then
xmlSaveFile ( database )
xmlUnloadFile ( database )
end
end)

function getClanData ( arg1, datatype )
if arg1 == false then return "false" end
local md5 = md5(arg1)
    if ( md5 ) then
        if ( database ) then
            local usersNode = xmlFindChild ( database, "user", 0 )
            if ( usersNode ) then
                local playerdatabaseNode = xmlFindChild ( usersNode, "ID_" .. md5, 0 )
                if not ( playerdatabaseNode == false ) then
                    local playerData = xmlNodeGetAttribute ( playerdatabaseNode, datatype )
                    if ( playerData ) then
                        --xmlUnloadFile ( database )
                        return playerData
                    else
                        --xmlNodeSetAttribute ( playerdatabaseNode, datatype, 0 )
                        --xmlSaveFile ( database )
                        --xmlUnloadFile ( database )
                        return "false"
                    end
                else
                    --local playerdatabaseNode = xmlCreateChild ( usersNode, "ID_" .. md5 )
                    --xmlNodeSetAttribute ( playerdatabaseNode, datatype, 0 )
                    --xmlSaveFile ( database )
                    --xmlUnloadFile ( database )
                    return "false"
                end
            end
        end
    end
end

function destroyClanData ( arg1 )
if arg1 == false then return "false" end
local md5 = md5(arg1)
    if ( md5 ) then
        if ( database ) then
            local usersNode = xmlFindChild ( database, "user", 0 )
            if ( usersNode ) then
                local playerdatabaseNode = xmlFindChild ( usersNode, "ID_" .. md5, 0 )
                if not ( playerdatabaseNode == false ) then
                        xmlDestroyNode( playerdatabaseNode )
						xmlSaveFile ( database )
						--xmlUnloadFile ( database )
                end
            end
        end
    end
end
 
function setClanData ( arg1, datatype, newvalue )
if arg1 == false then return "false" end
local md5 = md5(arg1)
    if ( md5 ) then
        if ( database ) then
            local usersNode = xmlFindChild ( database, "user", 0 )
            if ( usersNode ) then
                local playerdatabaseNode = xmlFindChild ( usersNode, "ID_" .. md5, 0 )
                if not ( playerdatabaseNode == false ) then
                    local newNodeValue = xmlNodeSetAttribute ( playerdatabaseNode, datatype, newvalue )
                    xmlSaveFile ( database )
                    --xmlUnloadFile ( database )
                    return newNodeValue
                else
                    local playerdatabaseNode = xmlCreateChild ( usersNode, "ID_" .. md5 )
                    local newNodeValue = xmlNodeSetAttribute ( playerdatabaseNode, datatype, newvalue )
                    xmlSaveFile ( database )
                    --xmlUnloadFile ( database )
                    return newNodeValue
                end
            end
        end
    end
end

addCommandHandler("tkst",
function(me, _, type, value, ...)
	local team = table.concat({...}, " ")
	setClanData(team, type, value)
end)

function getAllClanData ()
	if (database) then
		local usersNode = xmlFindChild (database,"user",0)
		if (usersNode) then
			local allPlayers = xmlNodeGetChildren(usersNode)
			siraTable = {}
			for i,data in ipairs(allPlayers) do
					local isim = tostring(xmlNodeGetAttribute (data,"isim")) or "yok"
					local tag = tostring(xmlNodeGetAttribute (data,"tag")) or "yok"
					local kazanma = tonumber(xmlNodeGetAttribute (data,"kazanma")) or 0
					local birincilik = tonumber(xmlNodeGetAttribute (data,"birincilik")) or 0
					local renk = xmlNodeGetAttribute (data,"renk") or "yok"
					table.insert(siraTable, {isim,tag,kazanma,birincilik,renk})
					--[[
					allPlayersData[i] = {isim = isim,
					                     tag = tag,
										 kazanma = kazanma,
										 birincilik = birincilik,
					                     renk = renk,
										 }
					]]--
					--table.sort(allPlayersData, function(x,y) return x.kazanma > y.kazanma end)
				end
			end		
			--xmlUnloadFile (database)	
			return siraTable
		end
	end


function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end
