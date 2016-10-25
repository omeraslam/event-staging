var EditorSectionContainer = React.createClass({
    getInitialState: function() {
        return { items: this.props.items, current_selection: null, eventObj: this.props.eventObj, ticketObj: this.props.ticketObj }
    },
    getDefaultProps: function() {
        return { items: [], current_selection: null, eventObj: null}
    },

    componentDidMount: function() {
   
    },

    selectItem: function(item) {
        this.setState({current_selection: item})

    },
    onPanelUpdate: function() {

    },
    refreshNav: function() {

    },
    render: function() {
        return (
           <div>
                <EditorAsideSectionNav handleSelectItem={this.selectItem} />
                <EditorSectionFormContainer current_selection={this.state.current_selection} eventObj={this.state.eventObj} ticketObj={this.state.ticketObj}/>
            </div>
        )
   } 
});