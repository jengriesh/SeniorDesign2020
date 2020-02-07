for i = 100:136
    im = imread(sprintf('brain1/brain1_slice%d.png', i));
    figure;
    imshow(im);
    colormap(jet);
    saveas(gcf,sprintf('ColoredBrain/colorbrain%d.png', i));
end