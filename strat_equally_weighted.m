function [ x_optimal cash_optimal ] = strat_equally_weighted( x_init, cash_init, mu, Q, cur_prices )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    value_total=cur_prices*x_init+cash_init;%total value in hand
    weight=value_total/length(x_init);
    x_optimal=floor(weight./cur_prices)';
    transaction=0.005*abs(cur_prices*x_optimal-value_total);
    cash_optimal=value_total-cur_prices*x_optimal-transaction;
    
    if cash_optimal<0
        %Short of need to reduce transaction
        %choose the lowest price stock and reduce the share change number
        %by 1, until cash_optimal is positive
        while cash_optimal<0
            x_diff=x_optimal-x_init;%find changed share index
            cur_Buffer=cur_prices;%use this to find minimum changed price index
            [M I]=min(cur_Buffer);
            while x_diff(I)==0 %go to next least price
                cur_Buffer(I)=Inf;
                [M I]=min(cur_Buffer);
            end
            if x_optimal(I)<x_init(I)
                x_optimal(I)= x_optimal(I)+1;
            else
                x_optimal(I)= x_optimal(I)-1;
            end
            transaction=0.005*abs(cur_prices*x_optimal-value_total);
            cash_optimal=value_total-cur_prices*x_optimal-transaction;
        end
    end
    
    %%If cash left is more than minimum price+transaction fee, buy one more
    %%share
    [M I]=min(cur_prices);
    while (1+0.005)*M*1<=cash_optimal
        x_optimal(I)=x_optimal(I)+1;
        transaction=0.005*abs(cur_prices*x_optimal-value_total);
        cash_optimal=value_total-cur_prices*x_optimal-transaction;
    end
end

