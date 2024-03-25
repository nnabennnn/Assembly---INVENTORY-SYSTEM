
; INDIVIDUAL ASSINGMENT
; TP069019
; BENJAPORN HATTHI
; APD2F2305CS(CTB)



.model small
.stack 100h
.data

MAX_STOCK_COUNT equ 40

ItemRecords dw 00, 01, 02, 03, 04, 05, 06, 07, 08, 09
            db "light bulb",  "dustpan   ", "broom     ", "basket    ", "hanger    ", "iron      ", "saw       ", "Tablecloth", "scissors  ", "ladder    "
            dw 2, 9, 1, 2, 3, 8, 6, 3, 8, 10, 12, 13, 6, 17, 4, 19, 9, 2, 7, 5, 2, 1, 0, 0, 1, 1, 2, 1, 2, 0, '$'

StockNumber dw 2
stock_title equ 20
stock_amount equ 2
stock_cost equ 2
InventoryInfo dw 2, 1, 0, 2, 1, 0, 40, 10, 19, 13, '$' 
InventoryCost dw 5, 8, 4, 2, 4, 9, 8, 1, 8, 10, '$'
total_sales dw 0

DottedChars db '                           ','$'

NL equ 13           
NLF equ 10           
TS equ 9           
BS equ 32        

MainPageShow db NL, '   | STOCK INVENTORY SYSTEM |       ', NL, NLF, '*************************************', NL, NLF, NLF, '1. Display Stock', NL, NLF, '2. Add Stock', NL, NLF, '3. Sell Stock', NL, NLF, '4. Generate Stock Report', NL, NLF, '0. Go Out of Program', NL, NLF, '*************************************', NL, NLF, '$'
invalid_selection_msg db NL, NLF, 'Incorrect selection. Please choose only number.', NL, NLF, '$'

StockShowTitle db NL, NLF, '              | STOCK DISPLAY |          ', NL, NLF, '**********************************************', NL, NLF, 'Number', TS, 'Name', TS, TS, 'Price', TS, 'Quantity', NL, NLF, '$'
showStock_prompt db '**********************************************', NL, NLF, ' Items in low quantity, please Restock item  ', NL, NLF, '**********************************************', NL, NLF, '1. Go to Main Page', NL, NLF, '0. Go Out of Program', NL, NLF, 'Please make your selection: $'


ReplenishStockNumber dw ?
ReplenishStock_id dw ?



ReplenishStock_prompt db '**********************************************', NL, NLF, TS, TS, BS, BS, 'ADD ITEMS', NL, NLF, '**********************************************', NL, NLF, 'Enter item Number : $'
ReplenishStockAmout_prompt db NL, NLF, 'What amount to replenish (1-9):  $'
ReplenishStock_done_msg db NL, NLF, '      Stock replenished Done!', NL, NLF, '$'





SellStockNumber_prompt db '**********************************************', NL, NLF, TS, TS, BS, BS, 'SELL STOCK', NL, NLF, '**********************************************', NL, NLF, 'Enter item number : $'
SellStock_amount_prompt db NL, NLF, 'Enter the quantity to sell (1-9): $'
SellStock_done_msg db NL, NLF, '           Stock sold Done!', NL, NLF, '$'
didtStock_msg db NL, NLF, ' Failed to sell stock. Insufficient quantity!', NL, NLF, '$'




ReportTitle db NL, NLF, '        | STOCK SUMMARY REPORT SYSTEM |', NL, NLF, '**********************************************', NL, NLF, 'Number', TS, 'Item', TS, TS, 'Quantity Sold', TS, 'Totally', NL, NLF, '$'
SaleReportLabel db '**********************************************', NL, NLF, '         DAILY SALES SUMMARY REPORT', NL, NLF, '**********************************************', NL, NLF, '1. Go to Main Page', NL, NLF, '0. Go Out of Program', NL, NLF , NL, NLF, 'Please make your selection: $'




sellerEntering db NL, NLF, 'Please make your selection:  $'
choose_off db NL, NLF, ' ----  Good bye, Stock inventory system most welcome   ----','$'





.code
main proc
  mov ax, @data 
  mov ds, ax 
  
  call ShowMain
  
  mov ah, 01h 
  int 21h

  cmp al, '1'
  je showStockMenu
  
  cmp al, '2'
  je ReplenishStock_menu
  
  cmp al, '3'
  je SellStockMenu
  
  cmp al, '4'
  je GenerateReportMenu
  
  cmp al, '0'
  je EndMenu

  jmp main



showStockMenu:
    call CleanPage
    call showStock
    call seller_navi
    ret

ReplenishStock_menu:
    call CleanPage
    call showStock
    call ReplenishStock
    ret

SellStockMenu:
    call CleanPage
    call showStock
    call SellStock
    ret

GenerateReportMenu:
    call GenerateReport
    call report_navi
    ret

EndMenu:
    call CleanPage
    call EndSystem
    ret



seller_navi:
    lea dx, showStock_prompt
    mov ah, 09h
    int 21h

    mov ah, 01h 
    int 21h

    cmp al, '0'
    je EndMenu

    cmp al, '1'
    je main

    jmp main

    ret

report_navi:
    lea dx, SaleReportLabel
    mov ah, 09h
    int 21h

    mov ah, 01h 
    int 21h

    cmp al, '0'
    je EndMenu

    cmp al, '1'
    je main

    jmp main

    ret


ShowInteger:
    push bx
    mov bx, 10
    xor cx, cx

    BecomeLoopInner:
        xor dx, dx
        div bx
        add dl, '0'
        push dx
        inc cx
        cmp ax, 0
        jne BecomeLoopInner

    ShowSecondLoop:
        pop dx
        mov ah, 02
        int 21h
        dec cx
        cmp cx, 0
        jne ShowSecondLoop
        pop bx
        ret


intiger5:
    mov bx, ax
    cmp bx, 5
    jle Marking
    ret

showText:
    push ax 
    push bx
    push cx
    mov bx, dx 
    mov cx, 10 

ShowLoop:
    mov dl, [bx] 
    int 21h 
    inc bx 
    loop ShowLoop 

finish:
    pop cx 
    pop bx
    pop ax
    ret




Marking:
    push ax 
    push bx
    push cx
    mov bx, dx 
    mov cx, 10 

ShowLoop3:
    mov dl, [bx] 
    mov ah, 09h
    mov al, dl 
    mov bl, 0Eh 
    int 10h
    inc bx 
    loop ShowLoop3 

finish3:
    pop cx 
    pop bx
    pop ax
    ret



ShowMain:
    call CleanPage
    lea dx, MainPageShow
    mov ah, 09h
    int 21h
    
    lea dx, sellerEntering
    mov ah, 09h
    int 21h
    ret




showStock:
    mov dx, offset StockShowTitle
    mov ah, 09
    int 21h
    
    mov bp, 0
    lea si, ItemRecords

LoopBegin:
    mov ax, [si]
    cmp ax, 10
    ja done
    call ShowInteger
    call ShowBS

    mov dx, offset ItemRecords + 20
    add dx, bp
    call showText
    call ShowBS

    mov ax, [si + 140]
    call ShowInteger
    call ShowBS

    mov ax, [si + 120]
    call intiger5

    mov ax, [si + 120]
    call ShowInteger
    call ShowNext
    add bp, 10
    add si, 2
    jmp LoopBegin
done:
    ret




ReplenishStock:
    lea dx, ReplenishStock_prompt
    mov ah, 09h
    int 21h 
    mov ah, 01
    int 21h
    sub al, 30h 
    add al, al
    sub ax, 136

    mov ReplenishStockNumber, ax 
    lea dx, ReplenishStockAmout_prompt
    mov ah, 09h 
    int 21h

    mov ah, 01
    int 21h
    sub al, 30h
    sub ax, 256
    mov cx, ax
    lea si, ItemRecords
    add si, ReplenishStockNumber
    add cx, [si]
    mov word ptr [si], cx 
    
    call CleanPage
    call ShowNext
    call ShowBegin
    lea dx, ReplenishStock_done_msg
    mov ah, 09h 
    int 21h 
    call ShowBegin
    call showStock
    call seller_navi
    ret



SellStock:
    lea dx, SellStockNumber_prompt
    mov ah, 09h
    int 21h 

    mov ah, 01
    int 21h

    sub al, 30h
    add al, al 
    sub ax, 136 
    mov ReplenishStockNumber, ax 

    lea dx, SellStock_amount_prompt
    mov ah, 09h 
    int 21h

    mov ah, 01
    int 21h
    sub al, 30h
    sub ax, 256
    mov cx, ax

    lea si, ItemRecords
    add si, ReplenishStockNumber
    mov bx, [si] 
    sub bx, cx
    cmp bx, 0
    js NewAmout

    mov word ptr [si], bx
    jmp SoldAmount

NewAmout: 
    mov bx, [si]
    mov word ptr [si], bx
    call CleanPage
    call ShowNext
    call ShowBegin
    lea dx, didtStock_msg
    mov ah, 09h 
    int 21h 
    call ShowBegin
    call ShowNext
    call showStock
    call seller_navi
    ret 

SoldAmount:

    call sold_finish
    call CleanPage
    call ShowNext
    call ShowBegin
    lea dx, SellStock_done_msg
    mov ah, 09h
    int 21h

    call ShowBegin
    call ShowNext
    call showStock
    call seller_navi
    ret
    

sold_finish: 
    mov ax, StockNumber 
    sub ax, 120 
    mov StockNumber, ax
    lea si, ItemRecords 
    add si, StockNumber
    mov ax, [si]
    add cx, ax 
    mov word ptr [si], cx
    ret
  ret


GenerateReport:
    call CleanPage
    mov dx, offset ReportTitle
    mov ah, 09
    int 21h
    
    mov bp, 0
    lea si, ItemRecords
    mov bx, offset InventoryInfo
    mov di, offset InventoryCost 


    LoopBegin2:
        mov ax, [si] 
        cmp ax, 10 
        ja done2 
        call ShowInteger 
        call ShowBS

        mov dx, offset ItemRecords + 20 
        add dx, bp 
        call showText 
        call ShowBS


        mov ax, [bx] 
        call ShowInteger 
        call ShowExtraBS
        

        mov cx, [bx]
        mov ax, [di]
        mul cx
        call ShowInteger
        call ShowNext

        add bp, 10
        add si, 2 
        add bx, 2
        add di, 2
        jmp LoopBegin2 
        
    done2:
    ret


EndSystem:
  lea dx, choose_off
  mov ah, 09h
  int 21h  
  mov ah, 4ch
  int 21h




CleanPage:
    mov ah, 06h
    mov al, 0
    mov bh, 07h
    mov cx, 0
    mov dx, 184Fh
    int 10h
    ret

ShowLine:
    lea dx, DottedChars
    mov ah, 09h
    int 21h
    ret

ShowBS:
    mov dl, 9
    mov ah, 02
    int 21h
    ret

ShowExtraBS:
    mov dl, 9
    mov ah, 02
    int 21h
    int 21h
    ret

ShowNext:
    mov dl, 0ah
    mov ah, 02
    int 21h
    ret

ShowBegin:
    lea dx, DottedChars
    mov ah, 09h 
    int 21h 
    ret


main endp
end main



;------------------------------ Thank you, Have a nice day ---------------------