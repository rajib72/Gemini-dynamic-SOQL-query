import { LightningElement,track } from 'lwc';
import runGeminiQuery from '@salesforce/apex/textToSoql.convertToSoql';
import { NavigationMixin } from 'lightning/navigation';

export default class GeminiDynamicQuery extends NavigationMixin(LightningElement) {
    @track userInput = ''
    @track records = []
    @track columns = []
    @track isLoading = false
    @track error

    handleChange(event){
        this.userInput = event.target.value;

    }

    async handleSubmit(){
        this.isLoading = true
        this.error = null
        this.records = []

        try {
            const result = await runGeminiQuery({queryString : this.userInput});
            if(result && result.length){
                // this.records = result;

                // const first = result[0]
                // console.log('first--',JSON.stringify(first));
                
                // this.column = Object.keys(first).map(key =>({
                //     label: key,
                //     fieldName: key,
                //     sortable: true
                // }))

                // console.log('column--',this.column);

                this.records = result.map(rec => {
                    const keyValuePairs = Object.entries(rec)
                        .filter(([key]) => key !== 'attributes') // skip metadata
                        .map(([key, val]) => `${key}: ${val}`)
                        .join(' | ');
                    return keyValuePairs;
                });
                
            }else{
                this.error = 'No records found'
            }
        } catch (error) {
            this.error = error.body ? error.body.message : error.message;
        }finally {
            this.isLoading  = false
        }
    }

    handleNavigate(event) {
        const recordString = event.target.dataset.record; 
        // Example: "Id: 006xx00000ABC123 | Name: Big Deal | StageName: Closed Won"

        // Extract Id using regex
        const match = recordString.match(/Id:\s*(\w{15,18})/);
        if (!match) return;
        const recordId = match[1];

        // Navigate
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'view'
            }
        });
    }

}