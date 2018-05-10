function [Epoch_both_feet, Epoch_both_hands, Baseline_both_feet, Baseline_both_hands,trial_length_feet, trial_length_hand] = Epoching(psd, band)

    % Extract samples positions for both feet and both hands separately
    load('SPD/Event Window.mat')
    Start_End_Feet = Event_window(find(Event_window(:,1) == 771),:);
    Start_End_Hand = Event_window(find(Event_window(:,1) == 773),:);

    % extract continuous feedback event minimum length
    trial_length_feet = min(Start_End_Feet(:,5)-Start_End_Feet(:,4));
    trial_length_hand = min(Start_End_Hand(:,5)-Start_End_Hand(:,4));
    % extract baseline event (fixation) minimum length
    baseline_length_feet = min(Start_End_Feet(:,3)-Start_End_Feet(:,2));
    baseline_length_hand = min(Start_End_Hand(:,3)-Start_End_Hand(:,2));
    
    % Initialize psd matrices
    number_electrode = 16;
    num_trial = length(Start_End_Feet);
    Epoch_both_feet = zeros(trial_length_feet,length(band),num_trial);
    Epoch_both_hands = zeros(trial_length_hand,length(band),num_trial);
    Baseline_both_feet = zeros(baseline_length_feet,length(band),num_trial);
    Baseline_both_hands = zeros(baseline_length_hand,length(band),num_trial);

    for n_electrode = 1:number_electrode
        for trial_number = 1:num_trial
            % --> Both feet:

            % Continuous feedback
            trial_samples = [Start_End_Feet(trial_number,4):Start_End_Feet(trial_number,4) + trial_length_feet-1];
            Epoch_both_feet(:,:,trial_number, n_electrode) = psd(trial_samples, band, n_electrode);
            % Baseline:
            baseline_samples = [Start_End_Feet(trial_number,2):Start_End_Feet(trial_number,2) + baseline_length_feet-1];
            Baseline_both_feet(:,:,trial_number, n_electrode) = psd(baseline_samples, band, n_electrode);


            % --> Both hands:

            % Continuous feedback
            trial_samples = [Start_End_Hand(trial_number,4):Start_End_Hand(trial_number,4) + trial_length_feet-1];
            Epoch_both_hands(:,:,trial_number, n_electrode) = psd(trial_samples, band, n_electrode); 
            % Baseline
            baseline_samples = [Start_End_Hand(trial_number,2):Start_End_Hand(trial_number,2) + baseline_length_hand-1];
            Baseline_both_hands(:,:,trial_number, n_electrode) = psd(baseline_samples, band, n_electrode);
        end
    end


end