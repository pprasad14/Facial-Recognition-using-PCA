function [trainIndex,testIndex] = train_test_split()
    %% SPLIT THE TRAINING AND THE TESTING DATA
    testIndex0 = randperm(5);

    % Test images indexes
    testIndex1 = testIndex0(1):5: 160+testIndex0(1);
    testIndex2 = testIndex0(2):5: 160+testIndex0(2);
    testIndex = [ testIndex1 testIndex2]';

    % Training images indexes
    trainIndex1 = testIndex0(3):5: 160+testIndex0(3);
    trainIndex2 = testIndex0(4):5: 160+testIndex0(4);
    trainIndex3 = testIndex0(5):5: 160+testIndex0(5);
    trainIndex = [ trainIndex1 trainIndex2 trainIndex3]';

end

