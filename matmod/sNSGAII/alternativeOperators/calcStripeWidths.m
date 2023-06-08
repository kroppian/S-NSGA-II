function stripeWidths = calcStripeWidths(s, D)

    stripeWidth = floor((1-s)*D);

    stripeCount = floor(D/stripeWidth);

    stripeRemainder = D - stripeWidth*stripeCount;

    stripeWidths = ones(stripeCount,1)*stripeWidth;

    stripeWidths = stripeWidths + floor(stripeRemainder/stripeCount);

    finalRemainder =  D - sum(stripeWidths);

    stripeWidths(end) = stripeWidths(end) + finalRemainder;


end
