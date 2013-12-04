//
//  SurvivalTableController.m
//  TheClerk
//
//  Created by Matthew Parides on 9/17/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//
/* This class displays the list view of the survival guide */

#import "SurvivalTableController.h"

@interface SurvivalTableController ()

@end

@implementation SurvivalTableController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _localDB = [FavoritesManager getSharedInstance];
    _conditions = [[NSMutableArray alloc] init];
    [self loadConditions];
    _searchedConditionsArray = [[NSMutableArray alloc] initWithCapacity:[self.conditions count]];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ConditionViewController* destination = segue.destinationViewController;
    destination.condition = self.selectedCondition;
}

//start table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Survival Guide";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchedConditionsArray count];
    } else {
        return [self.conditions count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSMutableArray *leftUtilityButtons = [NSMutableArray new];
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                 title:@"Problem?"];
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:0.0f green:0.231f blue:0.188 alpha:1.0f]
                                                 title:@"Favorite"];
        
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier
                                  containingTableView:tableView // For row height and selection
                                   leftUtilityButtons:leftUtilityButtons
                                  rightUtilityButtons:rightUtilityButtons];
        cell.detailTextLabel.font = [ UIFont fontWithName: @"Arial" size: 17.0 ];
        cell.textLabel.font = [ UIFont fontWithName: @"Arial" size: 17.0 ];
        [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
        [[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
        cell.delegate = self;
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString *name = ((Condition*)[self.searchedConditionsArray objectAtIndex:indexPath.row]).name;
        cell.textLabel.text = name;
        //int index = [self.phoneOwnerArray indexOfObjectIdenticalTo:name];
        //cell.detailTextLabel.text = ((Condition*)[self.conditions objectAtIndex:index]).deptName;
    } else {
        NSString *name = ((Condition*)[self.conditions objectAtIndex:indexPath.row]).name;
        cell.textLabel.text = name;
        //cell.detailTextLabel.text = ((Condition*)[self.conditions objectAtIndex:index]).deptName;

    }
    
    return cell;
}

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    if (index == 0) {
        [self problemEmail:cell];
    }
    else if(index == 1) {
        [self performFavorite:cell];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        self.selectedCondition = [self.searchedConditionsArray objectAtIndex:indexPath.row];
    } else {
        self.selectedCondition = [self.conditions objectAtIndex:indexPath.row];
    }
    [self performSegueWithIdentifier:@"CondSeg" sender:self];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Condition* cond = ((Condition*)[self.conditions objectAtIndex:indexPath.row]);
    [self.localDB saveCondition:cond.name data:cond.text tags:cond.tags dept:cond.deptName];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Favorited"
                                                        message:@"This item has been added to your favorites!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

//end table view methods

//start swipe-button methods

-(void) performFavorite:(id) sender {
    // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(SWTableViewCell*)sender];
    Condition* cond = (Condition*)[self.conditions objectAtIndex:indexPath.row];
    [self.localDB saveCondition:cond.name data:cond.text tags:cond.tags dept:cond.deptName];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Favorited"
                                                    message:@"This item has been added to your favorites!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)problemEmail:(id)sender {
    // Email Subject
    NSString *emailTitle = @"The-Clerk Survival Guide Issue";
    // Email Content
    NSString *messageBody = @"Issue:";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"mmparides91@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
//end swipe-button methods


//start search bar methods

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	// Update the filtered array based on the search text and scope.
	
    // Remove all objects from the filtered search array
	[self.searchedConditionsArray removeAllObjects];
    
	// Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    NSArray *tempArray = [self.conditions filteredArrayUsingPredicate:predicate];
    
    /* if(![scope isEqualToString:@"All"]) {
     // Further filter the array with the scope
     NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF.category contains[c] %@",scope];
     tempArray = [tempArray filteredArrayUsingPredicate:scopePredicate];
     }*/
    
    self.searchedConditionsArray = [NSMutableArray arrayWithArray:tempArray];
}


#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark - Search Button

- (IBAction)goToSearch:(id)sender
{
    // If you're worried that your users might not catch on to the fact that a search bar is available if they scroll to reveal it, a search icon will help them
    // Note that if you didn't hide your search bar, you should probably not include this, as it would be redundant
    [self.searchBar becomeFirstResponder];
}



#pragma mark - UISearchBarDelegate Methods
/*
 - (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
 //move the search bar up to the correct location eg
 [UIView animateWithDuration:.4
 animations:^{
 searchBar.frame = CGRectMake(searchBar.frame.origin.x,
 0,
 searchBar.frame.size.width,
 searchBar.frame.size.height);
 }
 completion:^(BOOL finished){
 //whatever else you may need to do
 }];
 }
 
 - (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
 //move the search bar down to the correct location eg
 [UIView animateWithDuration:.4
 animations:^{
 searchBar.frame = CGRectMake(searchBar.frame.origin.x,
 searchBar.frame.origin.y,
 searchBar.frame.size.width,
 searchBar.frame.size.height);
 }
 completion:^(BOOL finished){
 //whatever else you may need to do
 }];
 }
 */

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UISearchBar *searchBar = self.searchDisplayController.searchBar;
    CGRect rect = searchBar.frame;
    rect.origin.y = MIN(0, scrollView.contentOffset.y);
    searchBar.frame = rect;
}

//end search bar methods

-(void) loadConditions {
    [self.conditions addObject:[[Condition alloc] initWithName:@"ABNORMAL VAGINAL BLEEDING" text:@"Normal menses :approx 60ml over 7 days. Normal cycle is every 21 to 35 days.\n Menorrhagia : bleeding in EXCESS of normal at regular intervals (ie heavy periods) -> ask how often changing pads/tampons \n Metrorrhagia: bleeding at irregular intervals (ie longer than 7 days, bleeding in between periods) \n Menometrorrhagia: prolonged bleeding at irregular intervals. DDx: pregnancy (consider ectopic pregnancy or trophoblastic disease), infection, uterine fibroids, polyps, adenomyosis, uterine ca, cervical ca, bleeding diathesis, dysfunctional uterine bleeding and thyroid dysfunction. \nSecondary amenorrhea: cessation of periods in previously menstruating women.  Always rule out pregnancy first!  \n•	Causes: obesity, rapid wt loss, excessive exercise, severe anxiety/emotional distress, PCOS, premature ovarian failure, thyroid dysfunction, brain/pituitary tumors, Drugs (busulfan, chemotherapy, cyclophosphamide, phenothiazenes)   \n•	If find possible cause, treat the cause. If no clear cause, check pituitary axis hormones (FSH, LH, testosterone, prolactin, TSH)   \n•	Next step is imaging (vaginal u/s) and test for withdrawal bleeding with progesterone challenge then if no bleed, estrogen challenge    \n•	If no withdrawal bleeding, normal hormones, refer to GYN" tags:@"blah blah blah" dept:@"Women's health"]];
    [self.conditions addObject:[[Condition alloc] initWithName:@"HYPERTENSIVE CRISIS" text:@"Causes: Pain, fever, anxiety, withdrawal (EtOH, opiates), drugs (amphetamines, cocaine), meds (NSAIDs, pseudoephedrine), volume overload (missing dialysis), medication non-compliance \nSecondary HTN: Primary renal disease, OCPs, pheochromocytoma, primary hyperaldosteronism, Cushing’s syndrome, hypo- or hyperthyroidism, hyperparathyroidism, obstructive sleep apnea, coarctation of the aorta (consider new onset young elderly) \nWorkup/management: \n•	Recheck BP manually, with appropriately sized cuff, in both arms \n•	Assess for end-organ damage (see hypertensive emergency below) by history (Headache? Vision changes? Chest pain? SOB?), exam (AMS? Focal neuro deficit? Crackles?), labs (BMP, CBC, cardiac markers, U/A; not end-organ damage but get tox screen), and standard studies (ECG, CXR), while considering further imaging (e.g. head CT/MRI for bleed or chest CT/TEE for dissection) \nHypertensive Urgency - SBP ≥ 180 or DBP ≥ 120 without end organ damage \n•	Asymptomatic BP elevations in chronic hypertensives do not require immediate correction with rapid-acting medications – the risk likely exceeds any possible benefit \n•	Use PO agents to lower BP in 24-48hrs \n1)Labetalol 200mg (good choice in stroke; avoid in CHF, bradycardia & AVB) \n2)Clonidine 0.2mg \n3)Captopril 25mg (make sure kidney function okay) \n4)Hydralazine 10mg \n5)Nitropaste 1” topical \nHypertensive Emergency - Increased BP and acute end-organ damage: \n1)Neuro: seizure, encephalopathy, hemorrhagic or ischemic stroke, papilledem \n2)Cardiac: ACS, CHF, aortic dissection \n 3)Renal: proteinuria, hematuria, acute renal failure; scleroderma renal crisis \n 4)Heme: MAHA \n 5)Obstetric: pre-eclampsia, eclampsia \nAortic dissection – ↓BP to <120/80 rapidly \nIschemic CVA – only treat if >220/120 or if thrombolysis or if other organ damage" tags:@"none" dept:@"Cardiology"]];
    [self.conditions addObject:[[Condition alloc] initWithName:@"ACUTE ABDOMINAL PAIN" text:@"1. All patients: focused history, vital signs and physical exam (abdominal exam, rectal exam for bleeding or melena, document stool guaiac though it can be unreliable in inpatient setting, jaundice, stigmata of liver disease).  Can consider GI cocktail 60 mL (contains Maalox, donnatal, viscous lidocaine). \n2. Any patient with unstable vitals (e.g. - fever, hypotension) or severe tenderness and rebound needs EMERGENT workup as acute abdomen and consider MICU consult. \n3. N/V OR constipation OR crampy, diffuse pain OR ⇑/⇓ bowel sound → KUB (flat and upright) to r/o obstruction.  Keep acute mesenteric ischemia in differential if negative KUB and h/o CAD, PVD, A. fib – may have pain out of proportion to exam.  Evaluate with CTA. \n4. Diarrhea → check fecal leukocytes, stool culture, and C. Diff toxin.  KUB to r/o obstruction if scant watery stool.  CT scan w/ contrast to eval for colitis if bloody diarrhea.  Treat like a GI bleed with 2 large bore IVs, resuscitate, and active Type and Screen. \n5. RUQ pain → check amylase, lipase, LFT, ABC and INR.  RUQ U/S is best test to evaluate hepatobiliary system.  Consider CXR to evaluate for pneumonia, or CT for PE. \n6. Epigastric pain → similar to RUQ pain.  Also get ultrasound if patient has pulsatile abdominal mass to r/o AAA. Check EKG for epigastric pain with nausea to rule out ACS if patient has risk factors for CAD. \n7. LUQ pain → ABC, CMP, amylase, lipase. Consider CXR to r/o pneumonia. Keep acute coronary syndrome in differential. \n8. Lower abdominal pain → B-hCG ± pelvic exam (check for cervical motion tenderness, GC, Chlamydia, wet prep) in all women of reproductive age, U/A, and pelvic ultrasound for ovarian torsion.  Consider CT scan (eval for diverticulitis if LLQ pain, appendicitis if RLQ pain). \n9. Liver disease, peritoneal dialysis, or abdominal cancer → do diagnostic paracentesis immediately to rule out SBP." tags:@"none" dept:@"GASTROENTEROLOGY"]];
    [self.conditions addObject:[[Condition alloc] initWithName:@"ANEMIA" text:@"Definition:  Males: Hgb< 13.5 g/dL (Hct < 41%).   Females: Hgb <12 g/dL (Hct < 36%). \nPhysiology: S/sx result from ↓O2 delivery and, if bleeding, hypovolemia.  Compensation includes increased tissue extraction (from 25%-> 60%) and increased stroke volume and heart rate. \nSx: Fatigue, dyspnea, DOE, presyncope/syncope, palpitations.  Potentially sx high output heart failure.  If CAD → chest pain.  If 2/2 bleed result in s/sx volume depletion → lassitude, muscle cramps, orthostasis, \nSigns: Pallor (palms/nailbeds/conjunctiva/MM), tachycardia, orthostatic hypotension,  grade 1-2 high freq systolic murmur at LU or LLSB \nOther:  Jaundice (hemolysis), LAD/HSM/Bone pain (malignancy) esp sternal pain (CML infiltration) or lytic lesions (MM/breast),  Petechiae (thrombocytopenia)/eechymoses  (coagulation abnl).   splenomegaly (thalassemia, neoplasm, chronic hemolysis). PICA/koilonychia (fe def),  glossitis (iron, folate, B12 defic), neurologic abnormalities (B12) \nCharacteristics:    (1) Morphology (microcytic vs normocytic vs macrocytic)   (2) Kinetics (decreased production vs increased destruction) \n\t1.	Morphology:  microcytic vs normocytic vs macrocytic.   Lab test – MCV \n\t2.	Kinetics: decreased production vs increased destruction/loss.  Lab test – reticulocyte count" tags:@"none" dept:@"Hematology"]];
    [self.conditions addObject:[[Condition alloc] initWithName:@"DAILY ICU CARE" text:@"•	Every patient gets a daily FASTHUG (Feeding, Analgesia, Sedation, Thrombosis prophylaxis, Head of bed up 30°, Ulcer prophylaxis, Glycemic control). \n•	Address code status/goals of care on every patient daily. \n•	All intubated patients should get daily interruption /lightening of sedation (Kress et al. NEJM 2000. 342:1471–1477). \n•	Patients may benefit from early physical therapy even in the ICU.  (Kress. Crit Care Med 2009. 37(10 Suppl):S442-7. \n•	Order restraints for intubated patients as needed.  RN will remind. \n•	Make sure to have bolus fentanyl/versed for intubated patients for agitation \n•	Know drips and ventilatory settings for rounds" tags:@"none" dept:@"INTENSIVE CARE"]];
}

- (void)dealloc {
    [_searchBar release];
    [super dealloc];
}
@end
