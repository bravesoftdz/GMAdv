unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls,crt;

type
  cheatRec=record
   caption :  string[11];
   mode    :  boolean;
   step    :  byte;
  end;

  persRec=record
    hp,
    hpall,
    coint,
    exp,
    lvl,
    nlvl,
    step,
    power,
    x,
    y,
    stepall : longint;
  end;
  worldRec=record
    count,
    hp,
    hpall,
    power,
    time : longint;
    opacity,
    active : boolean;
    caption : string[50];
  end;
  itemRec=record
   hp,
   power,
   step,
   atime,
   time: longint;
   name : string [50];
   end;

  { TForm1 }

  TForm1 = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    gameLoad: TButton;
    gameSave: TButton;
    gtimeLabel: TLabel;
    Image1: TImage;
    Label2: TLabel;
    infoUp: TLabel;
    hpUp: TLabel;
    powUp: TLabel;
    cointUp: TLabel;
    Shape1: TShape;
    streli: TLabel;
    powLabel: TLabel;
    Bevel4: TBevel;
    aboutButton: TButton;
    helpStatus: TButton;
    pauseButton: TButton;
    panel1: TImage;
    panel2: TImage;
    panel3: TImage;
    panel4: TImage;
    panel5: TImage;
    panel6: TImage;
    panel7: TImage;
    panel8: TImage;
    panel9: TImage;
    panel0: TImage;
    Label1: TLabel;
    hpLabel: TLabel;
    cointLabel: TLabel;
    expLabel: TLabel;
    lvlLabel: TLabel;
    statuslabel: TLabel;
    panelLabel: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label4: TLabel;
    log: TMemo;
    stepProgress: TProgressBar;
    Timer1: TTimer;
    procedure aboutButtonClick(Sender: TObject);
    procedure Bevel1ChangeBounds(Sender: TObject);
    procedure cointUpClick(Sender: TObject);
    procedure exitButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure gameLoadClick(Sender: TObject);
    procedure gameSaveClick(Sender: TObject);
    procedure helpStatusClick(Sender: TObject);
    procedure hpUpClick(Sender: TObject);
    procedure logKeyPress(Sender: TObject; var Key: char);
    procedure logChange(Sender: TObject);
    procedure pauseButtonClick(Sender: TObject);
    procedure powUpClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure NPCattack;
    procedure panelUp;
    procedure victory;

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
      pers  :persRec;
    world : array[1..50,1..50] of worldRec;
    item : array[1..10] of itemRec;
    gtime : longint;
    vragkolvo:integer;
     cells: array [1..15] of TBitMap;
     cheat : cheatRec;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.panelUp;
begin
if (pers.nlvl<pers.lvl) then
  begin
   bevel2.Visible:=true;
 hpUp.Visible:=true;
 powUp.Visible:=true;
 cointUp.Visible:=true;
 infoUp.Visible:=true;
 hpUp.Caption:='Увеличить здоровье до '+inttostr(pers.hpall+3);
 powUp.Caption:='Увеличить силу до '+inttostr(pers.power+1);
 cointUp.Caption:='Увеличить коинты до '+inttostr(pers.coint+30);
  end
else
begin
 bevel2.Visible:=false;
 hpUp.Visible:=false;
 powUp.Visible:=false;
 cointUp.Visible:=false;
 infoUp.Visible:=false;
end;
end;

procedure TForm1.NPCattack;
var i,j:byte;
begin

if world[pers.x+1,pers.y].caption='Враг' then
  begin
  pers.hp-=world[pers.x+1,pers.y].power;
  log.Append('Враг ударил вас на '+inttostr(world[pers.x+1,pers.y].power)+' здоровья.');
  end;

if world[pers.x-1,pers.y].caption='Враг' then
  begin
   pers.hp-=world[pers.x-1,pers.y].power;
  log.Append('Враг ударил вас на '+inttostr(world[pers.x-1,pers.y].power)+' здоровья.');
  end;

if world[pers.x,pers.y+1].caption='Враг' then
  begin
   pers.hp-=world[pers.x,pers.y+1].power;
  log.Append('Враг ударил вас на '+inttostr(world[pers.x,pers.y+1].power)+' здоровья.');
  end;

if world[pers.x,pers.y-1].caption='Враг' then
  begin
  pers.hp-=world[pers.x,pers.y-1].power;
  log.Append('Враг ударил вас на '+inttostr(world[pers.x,pers.y-1].power)+' здоровья.');
  end;
    if (pers.hp<1) then
      begin
      pers.hp:=0;
      log.Append('Вы проиграли. Мурчите, Наталья!');

      // заблочим всю карту
        for i:=1 to 50 do
        for j:=1 to 50 do
        begin
        world[i,j].caption:='Стена';
        world[i,j].opacity:=false;
        end;
      //
      Timer1.Enabled:=false;
      showmessage('Вы проиграли. Мурчите, Наталья!');
      form1.close;
      end;
end;

procedure mapRefrash;
var i,j,elem:byte;
    x,y:integer;
begin
 x:=0; y:=0;
 for i:=pers.x-4 to pers.x+4 do
 begin
 for j:=pers.y-4 to pers.y+4 do
 begin
     if (world[i,j].caption='Дорога') then elem:=1
     else
     if (world[i,j].caption='Стена') then elem:=2
     else if (world[i,j].caption='Коинт') then elem:=3
     else if (world[i,j].caption='Враг') then elem:=4
     else if (world[i,j].caption='Перс_вниз') then elem:=5
     else if (world[i,j].caption='Перс_вверх') then elem:=6
      else if (world[i,j].caption='Перс_влево') then elem:=7
       else if (world[i,j].caption='Перс_вправо') then elem:=8;
  //if (world[i,j].caption<>'Дорога') then
  Form1.shape1.canvas.Draw(x,y, cells[elem]);
  x+=48;
 end;
 x-=48*9;
 y+=48;
 end;

       if (world[pers.x,pers.y].caption='Коинт') then
       begin
       world[pers.x,pers.y].caption:='Перс_вниз';
       pers.coint+=world[pers.x,pers.y].count;
       form1.log.append('[INFO] Вы получили '+inttostr(world[pers.x,pers.y].count)+' коинтов');
       end;

       //form1.log.Append('Ваши координаты:'+inttostr(pers.x)+':'+inttostr(pers.y));
end;

procedure TForm1.logChange(Sender: TObject);
begin

end;


procedure TForm1.pauseButtonClick(Sender: TObject);
begin
       if (pauseButton.Caption='Пауза') then
       begin
       pauseButton.Caption:='Возобновить';
       Timer1.Enabled:=false;
       end
       else
       begin
        pauseButton.Caption:='Пауза';
        Timer1.Enabled:=true;
       end;
end;

procedure TForm1.victory;
var i,j:byte;
begin
if vragkolvo=0 then
 begin
 for i:=pers.x-4 to pers.x+4 do
 for j:=pers.y-4 to pers.y+4 do
 world[i,j].caption:='Коинт';
 mapRefrash;
 //
       Timer1.Enabled:=false;
 //
 showmessage('Поздравляем! Вы победили!');
 form1.close;
 end;
end;

procedure TForm1.powUpClick(Sender: TObject);
begin
  pers.power+=1;
  pers.nlvl+=1;
  panelUp; //Покажем панель апов
end;


function pow(a,b:integer):longint;
var i:integer;
begin
  pow:=1;
  for i:=1 to b do
  pow*=a;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  nlvl    :  longint;
  i,j,k   :  byte;
  flag    :  boolean;

begin
  log.SetFocus;
  victory;
  randomize;
   j:=random(50)+1;
   k:=random(50)+1;
   if (world[j,k].caption='Дорога') then
   begin
  world[j,k].caption:='Стена';// уничтожим карту
  world[j,k].opacity:=false;
   end;
   //
   // заставим двигаться врагов
   flag:=false;
   for i:=pers.x-4 to pers.x+4 do
   begin
   for j:=pers.y-4 to pers.y+4 do
   if (world[i,j].caption='Враг') then
    begin

    if (i>pers.x) and (world[i-1,j].caption='Дорога') then
     begin
     world[i-1,j]:=world[i,j];
     world[i,j].caption:='Дорога';
     world[i,j].opacity:=true;
     flag:=true;
     break;
     end
    else if (i<pers.x) and (world[i+1,j].caption='Дорога')  then
      begin
     world[i+1,j]:=world[i,j];
     world[i,j].caption:='Дорога';
     world[i,j].opacity:=true;
     flag:=true;
     break;
     end
    else if (j>pers.y) and (world[i,j-1].caption='Дорога') then
      begin
      world[i,j-1]:=world[i,j];
     world[i,j].caption:='Дорога';
     world[i,j].opacity:=true;
      flag:=true;
      break;
      end
    else if (j<pers.y) and (world[i,j+1].caption='Дорога') then
      begin
     world[i,j+1]:=world[i,j];
     world[i,j].caption:='Дорога';
     world[i,j].opacity:=true;
      flag:=true;
      break;
     end;
    end;
    if (flag=true) then break;
   end;
   //
  mapRefrash; //обновим содержимое карты
  NPCattack;//Заставим врагов нас атаковать
  panelUp; //Выводим панель увеличения статов
  nlvl := pow(3,pers.lvl);
  gtime+=1; // за каждый шаг увеличиваем время в игре на 1.
  gtimeLabel.Caption:=inttostr(gtime);

  if (pers.step<pers.stepall) then pers.step+=1 //увеличим кол-во доступных шагов
  else if (pers.hp<pers.hpall) then pers.hp+=1; //При полных шагах, разрешим излечение 1хр в сек
  stepProgress.Max:=pers.stepall;
  stepProgress.Position:=pers.step;
  hpLabel.Caption:='HP:'+inttostr(pers.hp)+'/'+inttostr(pers.hpall);
  cointLabel.Caption:='COINT:'+inttostr(pers.coint);
  expLabel.Caption:='EXP:'+inttostr(pers.exp)+'/'+inttostr(nlvl);
  lvlLabel.Caption:='LVL:'+inttostr(pers.lvl);
  powLabel.Caption:='POW:'+inttostr(pers.power);
  streli.Caption:=inttostr(item[3].power);
  if (nlvl<=pers.exp) then
  begin
     pers.exp:=0;
     pers.lvl+=1;
     log.Append('[INFO] Получен новый уровень.');
     panelUp; //Покажем панель апов
  end;
  if (pers.hp<2) then log.Append('[WARNING] Мало здоровья.');
  //ап лвл

end;

procedure TForm1.Bevel1ChangeBounds(Sender: TObject);
begin

end;

procedure TForm1.cointUpClick(Sender: TObject);
begin
pers.coint+=30;
pers.nlvl+=1;
panelUp; //Покажем панель апов
end;

procedure TForm1.aboutButtonClick(Sender: TObject);
begin
  if (pauseButton.Caption='Пауза') then pauseButtonClick(aboutButton);
  showmessage('GMAdventure. Игра собрана на коленке. Связаться с разработчиком можно по адресу: stalker009@inbox.ru');
end;

procedure TForm1.exitButtonClick(Sender: TObject);
begin
  form1.Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i,j,rand:byte;
  img:string[20];
begin
  //
   cheat.caption:='cheatmodeon';
   cheat.mode:=false;
   cheat.step:=1;
  //
//
for i:=1 to 10 do
  begin
cells[i]:=TBitMap.Create;
cells[i].width:=48;
cells[i].height:=48;
case i of
1:img:='img\1.bmp';
2:img:='img\0.bmp';
3:img:='img\coint.bmp';
4:img:='img\vrag.bmp';
5:img:='img\pers_down.bmp';
6:img:='img\pers_up.bmp';
7:img:='img\pers_left.bmp';
8:img:='img\pers_right.bmp';
9:img:='img\weapon.bmp';
10:img:='img\strela.bmp';
end;
cells[i].LoadFromFile(img);
  end;
cells[9].TransparentColor:=clwhite;
cells[9].Transparent:=true;
cells[9].TransparentMode:=tmFixed;
cells[9].Canvas.Brush.Color:=clwhite;

cells[10].TransparentColor:=clwhite;
cells[10].Transparent:=true;
cells[10].TransparentMode:=tmFixed;
cells[10].Canvas.Brush.Color:=clwhite;
{cells[10].TransparentColor:=clwhite;
cells[10].Transparent:=true;
cells[10].TransparentMode:=tmFixed;
cells[10].Canvas.Brush.Color:=clwhite;}
//////


randomize;
////////////////////////////////////////////////////////////
  for i:=1 to 4 do                       ////////////////////
  for j:=1 to 50 do                      ///////////////////
  begin                                  ///////////////////
  world[i,j].caption:='Стена';            //////////////////
       world[i,j].opacity:=false;
  end;
  for i:=45 to 50 do
  for j:=1 to 50 do
  begin
       world[i,j].caption:='Стена';
       world[i,j].opacity:=false;
  end;
  for i:=1 to 50 do
  for j:=1 to 5 do                         //Границы карты (для предотвращения
                                          //ошибок сегментации памяти)
  begin
  world[i,j].caption:='Стена';
       world[i,j].opacity:=false;
  end;
  for i:=1 to 50 do
  for j:=45 to 50 do
  begin
       world[i,j].caption:='Стена';       /////////////////////
       world[i,j].opacity:=false;         ///////////////////
  end;                                     ///////////////////
  ///////////////////////////////////////////////////////////


  for i:=5 to 45 do
  for j:=5 to 45 do
  begin
     rand:=random(100);
       if (rand<7) then //Разбрасываем коинты
       begin
       world[i,j].count:=random(10)+1;
       world[i,j].opacity:=true;
       world[i,j].caption:='Коинт';
       end
       else if (rand<10) then //непроходимые блоки
       begin
       world[i,j].caption:='Стена';
       world[i,j].opacity:=false;
       end
       else if (rand<12) then //расставим врагов
       begin
       world[i,j].caption := 'Враг';
       world[i,j].opacity := false;
        world[i,j].hpall := random(10)+1;
       world[i,j].hp := world[i,j].hpall;
        world[i,j].power:=random(1)+1;
         world[i,j].active:=true;
          world[i,j].time:=random(360)+1;
          vragkolvo+=1;
       end
       else //расставим блоки для перемещения
       begin
        world[i,j].caption := 'Дорога';
        world[i,j].opacity := true;
       end;
  end;
  //мир создан, создаем персонажа
  pers.hpall    := 30;
  pers.hp       := pers.hpall;
  pers.coint    := 10;
  pers.exp      := 0;
  pers.lvl      := 0;
  pers.nlvl     := 0;
  pers.stepall  := 10;
  pers.step     := pers.stepall;
  pers.power    :=1;
  pers.x        :=10;
  pers.y        :=10;
  world[10,10].caption:='Перс_вниз';
  //персонаж создан, создадим базовый инвентарь
  //
  item[2].hp:=10;
  item[2].atime:=60; //время перезарядки
  item[2].time:=0;
  item[2].name:='Зелье здоровья';
  //
  item[4].time:=0;
  //
  item[3].power:=0;
  //

  log.Append('[QUEST] Ваша миссия уничтожить всех врагов ('+inttostr(vragkolvo)+')');
end;

procedure TForm1.gameLoadClick(Sender: TObject);
var
  fworld  :    file of worldRec;
  fpers   :    file of persRec;
  fitem   :    file of itemRec;
  fgtime  :    file of integer;
  i,j     :    byte;
begin
  try
  assignFile (fworld,'save\world.dat');
  assignFile (fpers,'save\pers.dat');
  assignFile (fitem,'save\item.dat');
  assignFile (fgtime,'save\gtime.dat');
  reset(fworld);
  reset(fpers);
  reset(fitem);
  reset(fgtime);
  except
    showmessage ('Сохранение отсутствует!');
  end;
  for i:=1 to 50 do
  for j:=1 to 50 do
  read(fworld,world[i,j]);
  read(fpers,pers);
  for i:=1 to 10 do
  read(fitem,item[i]);

  read(fgtime,gtime);

  closeFile(fworld);
  closeFile(fpers);
  closeFile(fitem);
  closeFile(fgtime);

  showmessage('Игра успешно загружена.');
end;

procedure TForm1.gameSaveClick(Sender: TObject);
var
  fworld  :    file of worldRec;
  fpers   :    file of persRec;
  fitem   :    file of itemRec;
  fgtime  :    file of integer;
  i,j     :    byte;
begin
  try
  mkdir('save');
  except end;
  assignFile (fworld,'save\world.dat');
  assignFile (fpers,'save\pers.dat');
  assignFile (fitem,'save\item.dat');
  assignFile (fgtime,'save\gtime.dat');
  rewrite(fworld);
  rewrite(fpers);
  rewrite(fitem);
  rewrite(fgtime);
  for i:=1 to 50 do
  for j:=1 to 50 do
  write(fworld,world[i,j]);
  write(fpers,pers);
  for i:=1 to 10 do
  write(fitem,item[i]);

  write(fgtime,gtime);

  closeFile(fworld);
  closeFile(fpers);
  closeFile(fitem);
  closeFile(fgtime);

  showmessage('Игра успешно сохранена.');
end;

procedure TForm1.helpStatusClick(Sender: TObject);
begin

end;

procedure TForm1.hpUpClick(Sender: TObject);
begin
  pers.hpall+=3;
  pers.nlvl+=1;
  panelUp; //Покажем панель апов
end;

procedure TForm1.logKeyPress(Sender: TObject; var Key: char);
var
  i,j:byte;
  flag:boolean;
begin
  //читы
  if (cheat.mode=true)  then
  begin
  if (key='j') then pers.step:=pers.stepall+200
  else if (key='k') then pers.coint+=500
  else if (key='l') and (pers.lvl<19) then pers.lvl+=1
  else if (key=';') then pers.power+=5;
  if (key='j') or (key='k') or (key='l') or (key=';') then
    begin
    log.Append('[SUPER] Чит активирован. Чит режим выключен.');
    cheat.mode:=false;
    cheat.step:=1;
    end;
    end
  else
  begin
  if (key=cheat.caption[cheat.step]) then cheat.step+=1
  else cheat.step:=1;
  if (cheat.step=6) then
    begin
    cheat.mode:=true;
    log.Append('[SUPER] Чит-коды разрешены.');
    end;
  end;
  //читы

  if (pers.step>0) and (pauseButton.Caption='Пауза') then
  begin

       case key of
       #115: if(world[pers.x+1,pers.y].opacity=true) then begin world[pers.x,pers.y].caption:='Дорога'; pers.x+=1; if (world[pers.x,pers.y].caption='Дорога') then world[pers.x,pers.y].caption:='Перс_вниз'; end;
       #119:if(world[pers.x-1,pers.y].opacity=true) then begin world[pers.x,pers.y].caption:='Дорога'; pers.x-=1; if (world[pers.x,pers.y].caption='Дорога') then world[pers.x,pers.y].caption:='Перс_вверх';  end;
       #100:if(world[pers.x,pers.y+1].opacity=true) then begin world[pers.x,pers.y].caption:='Дорога'; pers.y+=1; if (world[pers.x,pers.y].caption='Дорога') then world[pers.x,pers.y].caption:='Перс_вправо';  end;
       #97: if(world[pers.x,pers.y-1].opacity=true) then begin world[pers.x,pers.y].caption:='Дорога'; pers.y-=1; if (world[pers.x,pers.y].caption='Дорога') then world[pers.x,pers.y].caption:='Перс_влево'; end;
       end;
       mapRefrash; //обновим карту
  if ((key=#97) or (key=#100) or (key=#115) or (key=#119)) then pers.step-=1;
  end;
  //панель быстрого доступа
  if (key='4') then
  begin
  if (pers.coint>30) then
  begin
  if (item[4].time+10<gtime) then
  begin
  pers.coint-=15;
  item[4].time:=gtime;
  pers.hp+=5;
  if (pers.hp>pers.hpall) then pers.hp:=pers.hpall;
  log.Append('[INFO] Супер морковь успешно съедена.');
  end
  else log.Append('[WARNING] Супер морковь можно кушать раз в 10 секунд. ');
  end
  else log.Append('[WARNING] Недостаточно коинтов. Необходимо 30 штук.');
  end;

  if (key='3') then //покупаем стрелы
  begin
  if pers.coint<30 then log.Append('[WARNING] Необходимо 30 коинтов для покупки стрелы.')
  else
begin
if (item[3].power<99) then
begin
pers.coint-=30;
item[3].power+=1;
log.Append('[INFO] Стрела успешно куплена.');
end
else log.Append('[WARNING] Достигнут лимит стрел.');
end;
  end;

if (key='2') then
begin
flag:=false;
if (item[3].power>0) then
begin
for i:=pers.x-4 to pers.x+4 do
begin
for j:=pers.y-4 to pers.y+4  do
begin
if world[i,j].caption='Враг' then
begin
shape1.Canvas.Draw(4*48+((j-pers.y)*48),4*48+((i-pers.x)*48),cells[10]);
world[i,j].caption:='Дорога';
world[i,j].opacity:=true;
pers.exp+=world[i,j].power;
log.Append('[INFO] Вы уничтожили врага и получили '+inttostr(world[i,j].power)+' опыта.');
log.Append('[INFO] Потрачена стрела');
vragkolvo-=1;
item[3].power-=1;
log.Append('[QUEST] Осталось врагов: '+inttostr(vragkolvo));
flag:=true;
end;
if (flag=true) then break;
end;
if (flag=true) then break;
end;
end
else log.Append('[WARNING] Для стрельбы из лука нужны стрелы!');
end;

if (key='5') then
begin
if (pers.coint<50) then log.Append('[WARNING] Недостаточно коинтов. Для использования необходимо 50 коинтов.')
else
  begin
  if (world[pers.x-1,pers.y].caption='Стена') and (pers.x-1>4) then
  begin
  world[pers.x-1,pers.y].caption:='Дорога';
  world[pers.x-1,pers.y].opacity:=true;
  end;
   if (world[pers.x+1,pers.y].caption='Стена') and (pers.x+1<46) then
  begin
  world[pers.x+1,pers.y].caption:='Дорога';
  world[pers.x+1,pers.y].opacity:=true;
  end;
    if (world[pers.x,pers.y-1].caption='Стена') and (pers.y-1>4) then
  begin
  world[pers.x,pers.y-1].caption:='Дорога';
  world[pers.x,pers.y-1].opacity:=true;
  end;

     if (world[pers.x,pers.y+1].caption='Стена') and (pers.y+1<46) then
  begin
  world[pers.x,pers.y+1].caption:='Дорога';
  world[pers.x,pers.y+1].opacity:=true;
  end;
     log.Append('[INFO] Топор использован.');
     pers.coint-=50;
  end;

end;

//основной элемент боя
if (key='1') and (pers.step>0) then
begin
   if (world[pers.x-1,pers.y].caption='Враг') then
     begin
     world[pers.x-1,pers.y].hp-=pers.power;
     if (world[pers.x-1,pers.y].hp<1) then
       begin
       world[pers.x-1,pers.y].hp:=0;
       world[pers.x-1,pers.y].caption:='Дорога';
       world[pers.x-1,pers.y].opacity:=true;
       vragkolvo-=1;
       log.Append('[QUEST] Враг уничтожен, осталось '+inttostr(vragkolvo)+' врагов');
       randomize;
       pers.exp+=+world[pers.x-1,pers.y].power+random(10);
       log.Append('[INFO] Получено '+inttostr(world[pers.x-1,pers.y].power)+' опыта');
       end;
     log.Append('[INFO] Вы ударили врага на '+inttostr(pers.power)+' осталось '+inttostr(world[pers.x-1,pers.y].hp)+' здоровья.');
       pers.step-=1;
     end
     else if (world[pers.x+1,pers.y].caption='Враг') then
     begin
       world[pers.x+1,pers.y].hp-=pers.power;
     if (world[pers.x+1,pers.y].hp<1) then
       begin
        victory; //проверим победили ли?
       world[pers.x+1,pers.y].hp:=0;
       world[pers.x+1,pers.y].caption:='Дорога';
       world[pers.x+1,pers.y].opacity:=true;
       vragkolvo-=1;
       log.Append('[QUEST] Враг уничтожен, осталось '+inttostr(vragkolvo)+' врагов');
       pers.exp+=world[pers.x+1,pers.y].power+random(10);;
       log.Append('[INFO] Получено '+inttostr(world[pers.x+1,pers.y].power)+' опыта');
       end;
     log.Append('[INFO] Вы ударили врага на '+inttostr(pers.power)+' осталось '+inttostr(world[pers.x+1,pers.y].hp)+' здоровья.');
       pers.step-=1;
     end
     else  if (world[pers.x,pers.y-1].caption='Враг') then
     begin

         world[pers.x,pers.y-1].hp-=pers.power;
     if (world[pers.x,pers.y-1].hp<1) then
       begin
        victory; //проверим победили ли?
       world[pers.x,pers.y-1].hp:=0;
       world[pers.x,pers.y-1].caption:='Дорога';
       world[pers.x,pers.y-1].opacity:=true;
       vragkolvo-=1;
       log.Append('[QUEST] Враг уничтожен, осталось '+inttostr(vragkolvo)+' врагов');
       pers.exp+=world[pers.x,pers.y-1].power+random(10);;
       log.Append('[INFO] Получено '+inttostr(world[pers.x,pers.y-1].power)+' опыта');
       end;
     log.Append('[INFO] Вы ударили врага на '+inttostr(pers.power)+' осталось '+inttostr(world[pers.x,pers.y-1].hp)+' здоровья.');
       pers.step-=1;

     end

     else   if (world[pers.x,pers.y+1].caption='Враг') then
     begin
          world[pers.x,pers.y+1].hp-=pers.power;
     if (world[pers.x,pers.y+1].hp<1) then
       begin
        victory; //проверим победили ли?
       world[pers.x,pers.y+1].hp:=0;
       world[pers.x,pers.y+1].caption:='Дорога';
       world[pers.x,pers.y+1].opacity:=true;
       vragkolvo-=1;
       log.Append('[QUEST] Враг уничтожен, осталось '+inttostr(vragkolvo)+' врагов');
       pers.exp+=world[pers.x,pers.y+1].power+random(10);;
       log.Append('[INFO] Получено '+inttostr(world[pers.x,pers.y+1].power)+' опыта');
       end;
     log.Append('[INFO] Вы ударили врага на '+inttostr(pers.power)+' осталось '+inttostr(world[pers.x,pers.y+1].hp)+' здоровья.');
       pers.step-=1;
     end;
      shape1.Canvas.Draw(4*48,4*48,cells[9]);
end;
//основной элемент боя

  //панель быстрого доступа
   key:=#0;
  end;


end.

